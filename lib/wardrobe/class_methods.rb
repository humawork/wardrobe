# frozen_string_literal: true

require 'forwardable'

module Wardrobe
  module ClassMethods
    extend Forwardable
    def_delegators :@wardrobe_stores, :attribute_store, :plugin_store, :option_store

    def self.extended(base)
      wardrobe_methods = base.instance_variable_set(:@wardrobe_methods, Module.new)
      base.include(wardrobe_methods)
      base.instance_variable_set(:@wardrobe_stores, Stores.new)
    end

    # This is called when included in another module/class
    def included(base)
      base.include(Wardrobe) unless base.respond_to? :wardrobe_stores
      base.merge(wardrobe_stores)
    end

    def inherited(child)
      wardrobe_methods = child.instance_variable_set(:@wardrobe_methods, Module.new)
      child.include(wardrobe_methods)
      child.instance_variable_set(:@wardrobe_stores, Stores.new)
      child.merge(wardrobe_stores)
      child.root_config = root_config
    end

    def wardrobe_stores(&blk)
      if block_given?
        @wardrobe_stores = wardrobe_stores.update(&blk)
      else
        @wardrobe_stores
      end
    end

    def root_config=(input)
      @root_config = input
    end

    def root_config
      @root_config if instance_variable_defined?(:@root_config)
    end

    def default_getters
      [
        Wardrobe.getters[:getter]
      ]
    end

    def default_setters
      [
        Wardrobe.setters[:setter]
      ]
    end

    def merge(config)
      @wardrobe_stores = wardrobe_stores.merge(config, self)
    end

    def define_getter(atr)
      @wardrobe_methods.instance_exec do
        define_method(atr.name) do
          atr.getters.inject(nil) do |val, getter|
            getter.block.call(val, atr, self)
          end
        end
      end
    end

    def define_setter(atr)
      @wardrobe_methods.instance_exec do
        define_method(atr.setter_name) do |input|
          atr.setters.inject(input) do |val, setter|
            setter.block.call(val, atr, self)
          end
        end
      end
    end


    def attribute(name, klass, *args, &blk)
      merged_args = option_store.defaults.merge(args.inject({}) { |input, val| input.merge! val })
      @wardrobe_stores = wardrobe_stores.add_attribute(
        name, klass, self, **merged_args, &blk
      )
      define_getter(attribute_store[name])
      define_setter(attribute_store[name])
    end

    def attributes(**kargs, &blk)
      BlockSetup.new(self).run(**kargs, &blk)
    end

    def remove_attributes(*wardrobe)
      wardrobe.each do |name|
        @wardrobe_stores = wardrobe_stores.remove_attribute(name)
      end
    end

    alias remove_attribute remove_attributes

    def plugin(name, **args)
      @wardrobe_stores = wardrobe_stores.enable_plugin(name, **args)
      plugin = plugin_store[name][:klass]

      if plugin.const_defined?(:ClassMethods)
        extend(plugin.const_get(:ClassMethods))
      end

      if plugin.const_defined?(:InstanceMethods)
        include(plugin.const_get(:InstanceMethods))
      end

      # Currently these are not needed
      #
      # if plugin.const_defined?(:AttributeClassMethods)
      #   Attribute.extend(plugin.const_get(:AttributeClassMethods))
      # end
      #
      # if plugin.const_defined?(:AttributeInstanceMethods)
      #   Attribute.include(plugin.const_get(:AttributeInstanceMethods))
      # end
    end
  end
end
