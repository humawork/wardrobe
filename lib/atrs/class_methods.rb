module Atrs
  module ClassMethods
    def inherited(base)
      base.instance_variable_set(:@attribute_set, attribute_set)
      base.instance_variable_set(:@plugin_set, plugin_set)
      base.instance_variable_set(:@option_set, option_set)
    end

    def attribute(name, klass, **args, &blk)
      @attribute_set = attribute_set.add(name, klass, self, **args, &blk)
      atr = @attribute_set[name]
      define_getter(atr)
      define_setter(atr)
    end

    def merge(mod)
      if mod.const_defined?('InstanceMethods')
        include(mod.const_get('InstanceMethods'))
      end
      @plugin_set = plugin_set.merge(mod.plugin_set)
      mod.plugin_set.each do |name, plugin|
        init_plugin_modules(name)
      end
      @option_set = option_set.merge(mod.option_set)
      @attribute_set = attribute_set.merge(mod.attribute_set)
      mod.attribute_set.each do |name, atr|
        define_getter(atr)
        define_setter(atr)
      end
    end

    def define_getter(atr)
      define_method(atr.name) do
        instance_variable_get(atr.ivar_name)
      end
    end

    def define_setter(atr)
      options_with_setters = option_set.set.values.select do |v|
        v.options[:setter] && atr.options[v.name]
      end
      if options_with_setters.any?
        define_method(atr.setter_name) do |val|
          options_with_setters.each do |option|
            val = option.options[:setter].call(val, atr, self)
          end
          instance_variable_set(atr.ivar_name, val)
        end
      else
        define_method(atr.setter_name) do |val|
          instance_variable_set(atr.ivar_name, val)
        end
      end
    end

    def enable_plugin(name)
      super
      init_plugin_modules(name)
    end

    def init_plugin_modules(name)
      if mod = plugin_set[name].class_methods_module
        self.extend(mod)
      end
      if mod = plugin_set[name].instance_methods_module
        self.include(mod)
      end
    end

    def remove_plugins(*plugins)
      plugins.each do |atr|
        raise "Not implemented"
      end
    end

    alias remove_plugin remove_plugins

    def attributes(**kargs, &blk)
      # Should and could we init only once and reuse?
      BlockSetup.new(self).run(**kargs, &blk)
    end

    def remove_attributes(*atrs)
      atrs.each do |atr|
        @attribute_set = attribute_set.del(atr)
      end
    end

    alias remove_attribute remove_attributes

    def coerce(val, atr)
      new(**val) if val
    end
  end
end
