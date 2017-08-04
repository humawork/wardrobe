# frozen_string_literal: true

module Wardrobe
  class DefaultSettersStore < Store
    def initialize
      super({setter: Wardrobe.setters[:setter]})
    end
  end

  class DefaultGettersStore < Store
    def initialize
      super({getter: Wardrobe.getters[:getter]})
    end
  end

  class Config
    def self.registered_stores
      @registered_stores ||= {}.freeze
    end

    def self.register_store(name, klass)
      @registered_stores = registered_stores.merge(name => klass).freeze
    end

    register_store(:attribute_store, AttributeStore)
    register_store(:plugin_store, PluginStore)
    register_store(:option_store, OptionStore)
    register_store(:default_setters_store, DefaultSettersStore)
    register_store(:default_getters_store, DefaultGettersStore)

    attr_reader :stores, :instance_methods_module, :class_methods_module

    def initialize
      @stores = {}.freeze
      @instance_methods_module = Module.new.freeze
      @class_methods_module = Module.new.freeze
      self.class.registered_stores.each do |key, value|
        add_store(key, value, initializer: true)
      end
      freeze
    end

    def merge_wardrobe_config(other_wardrobe_config)
      @wardrobe_config = wardrobe_config.merge(other_wardrobe_config, self)
    end

    def self.create_and_add_to(object, merge_with: nil)
      config = new
      config = config.merge(merge_with, object) if merge_with
      object.instance_variable_set(:@wardrobe_config, config)
    end

    def add_instance_methods(klass, &blk)
      update do
        @instance_methods_module = instance_methods_module.dup
        instance_methods_module.class_exec(&blk)
        instance_methods_module.freeze
        klass.include(instance_methods_module)
      end
    end

    def add_class_methods(klass, &blk)
      update do
        @class_methods_module = class_methods_module.dup
        class_methods_module.class_exec(&blk)
        class_methods_module.freeze
        klass.extend(class_methods_module)
      end
    end

    def update(&blk)
      if frozen?
        dup.update(&blk)
      else
        instance_exec(&blk)
        freeze
      end
    end

    def add_store(name, klass, initializer: false)
      if frozen?
        dup.add_store(name, klass)
      else
        @stores = stores.merge(name => klass)
        instance_variable_set("@#{name}", klass.new)
        define_singleton_method(name) { instance_variable_get("@#{name}") }
        freeze unless initializer
      end
    end

    def merge(other, calling_object)
      if frozen?
        dup.merge(other, calling_object)
      else
        (other.stores.keys - stores.keys).each do |name|
          add_store(name, other.stores[name], initializer: true)
        end
        stores.each do |name, klass|
          next unless other.respond_to?(name)
          instance = respond_to?(name) ? send(name) : klass.new
          instance_variable_set(
            "@#{name}", instance.merge(other.send(name), calling_object, self)
          )
        end
        calling_object.include(other.instance_methods_module)
        calling_object.extend(other.class_methods_module)
        freeze
      end
    end

    def dup
      duplicate = super
      duplicate.stores.each do |name, _klass|
        duplicate.define_singleton_method(name) do
          instance_variable_get("@#{name}")
        end
      end
      duplicate
    end

    def enable_plugin(name, **args)
      if frozen?
        dup.enable_plugin(name, **args)
      else
        @plugin_store = plugin_store.add(name, **args)
        plugin_store[name][:klass].options.each do |option|
          @option_store = option_store.add(option.name, option)
        end
        freeze
      end
    end

    def add_attribute(name, klass, defining_object, **merged_args, &blk)
      if frozen?
        dup.add_attribute(name, klass, defining_object, **merged_args, &blk)
      else
        @attribute_store = attribute_store.add(
          name, klass, defining_object, self, **merged_args, &blk
        )
        freeze
      end
    end

    def remove_attribute(name)
      if frozen?
        dup.remove_attribute(name)
      else
        @attribute_store = attribute_store.del(name)
        freeze
      end
    end
  end
end
