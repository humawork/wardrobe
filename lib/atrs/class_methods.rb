# frozen_string_literal: true

require 'forwardable'

module Atrs
  module ClassMethods
    extend Forwardable
    def_delegators :@atrs_stores, :attribute_store, :plugin_store, :option_store

    def self.extended(base)
      atrs_methods = base.instance_variable_set(:@atrs_methods, Module.new)
      base.include(atrs_methods)
      base.instance_variable_set(:@atrs_stores, Stores.new)
    end

    # This is called when included in another module/class
    def included(base)
      base.include(Atrs) unless base.respond_to? :atrs_stores
      base.merge(atrs_stores)
    end

    def inherited(child)
      atrs_methods = child.instance_variable_set(:@atrs_methods, Module.new)
      child.include(atrs_methods)
      child.instance_variable_set(:@atrs_stores, Stores.new)
      child.merge(atrs_stores)
      child.root_config = root_config
    end

    def atrs_stores(&blk)
      if block_given?
        @atrs_stores = atrs_stores.update(&blk)
      else
        @atrs_stores
      end
    end

    def configure_atrs(&blk)
      @root_config = root_config.mutate(&blk)
    end

    def root_config=(input)
      @root_config = input
    end

    def root_config
      @root_config if instance_variable_defined?(:@root_config)
    end

    def default_getters
      [
        Atrs.getters[:getter]
      ]
    end

    def default_setters
      [
        Atrs.setters[:setter]
      ]
    end
    
    def merge(config)
      @atrs_stores = atrs_stores.merge(config, self)
    end

    def define_getter(atr)
      @atrs_methods.instance_exec do
        define_method(atr.name) do
          atr.getters.inject(nil) do |val, getter|
            getter.block.call(val, atr, self)
          end
        end
      end
    end

    def define_setter(atr)
      @atrs_methods.instance_exec do
        define_method(atr.setter_name) do |input|
          atr.setters.inject(input) do |val, setter|
            setter.block.call(val, atr, self)
          end
        end
      end
    end

    def attribute(name, klass, **args, &blk)
      merged_args = option_store.defaults.merge(args)
      @atrs_stores = atrs_stores.add_attribute(
        name, klass, self, **merged_args, &blk
      )
      define_getter(attribute_store[name])
      define_setter(attribute_store[name])
    end

    def attributes(**kargs, &blk)
      BlockSetup.new(self).run(**kargs, &blk)
    end

    def remove_attributes(*atrs)
      atrs.each do |name|
        @atrs_stores = atrs_stores.remove_attribute(name)
      end
    end

    alias remove_attribute remove_attributes

    def plugin(*plugin_names)
      plugin_names.each { |name| enable_plugin(name) }
    end

    def enable_plugin(name)
      @atrs_stores = atrs_stores.enable_plugin(name)
      plugin = plugin_store[name]
      if plugin.const_defined?(:ClassMethods)
        extend(plugin.const_get(:ClassMethods))
      end
      if plugin.const_defined?(:InstanceMethods)
        include(plugin.const_get(:InstanceMethods))
      end
    end
  end
end
