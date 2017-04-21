module Atrs
  module ClassMethods
    extend Forwardable
    def_delegators :@atrs_config, :attribute_store, :plugin_store, :option_store

    def self.extended(base)
      base.instance_variable_set(:@atrs_config, Config.new)
    end

    # This is called when included in another module/class
    def included(base)
      base.include(Atrs) unless base.respond_to? :atrs_config
      base.merge(atrs_config)
    end

    def atrs_config(&blk)
      if block_given?
        @atrs_config = atrs_config.update(&blk)
      else
        @atrs_config
      end
    end

    def inherited(child)
      child.instance_variable_set(:@atrs_config, Config.new)
      child.merge(atrs_config)
    end

    def merge(config)
      @atrs_config = atrs_config.merge(config, self)
    end

    def define_getter(atr)
      # getters = getters_for_atr(atr)
      define_method(atr.name) do
        atr.getters(self).inject(nil) { |val, getter|
          getter.block.call(val, atr, self)
        }
      end
    end

    def define_setter(atr)
      # setters = setters_for_atr(atr)
      define_method(atr.setter_name) do |input|
        atr.setters(self).inject(input) { |val, setter|
          setter.block.call(val, atr, self)
        }
      end
    end

    def attribute(name, klass, **args, &blk)
      merged_args = option_store.defaults.merge(args)
      @atrs_config = atrs_config.add_attribute(name, klass, self, **merged_args, &blk)
      define_getter(attribute_store[name])
      define_setter(attribute_store[name])
    end

    def attributes(**kargs, &blk)
      BlockSetup.new(self).run(**kargs, &blk)
    end

    def remove_attributes(*atrs)
      atrs.each do |name|
        @atrs_config = atrs_config.remove_attribute(name)
      end
    end

    alias remove_attribute remove_attributes

    def plugin(*plugin_names)
      plugin_names.each { |name| enable_plugin(name) }
    end

    def enable_plugin(name)
      @atrs_config = atrs_config.enable_plugin(name)
      plugin = plugin_store[name]
      if plugin.const_defined?(:ClassMethods)
        extend(plugin.const_get(:ClassMethods))
      end
      if plugin.const_defined?(:InstanceMethods)
        include(plugin.const_get(:InstanceMethods))
      end
    end

    def coerce(val, atr)
      val ? new(**val) : new
    end
  end
end
