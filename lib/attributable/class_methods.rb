module Attributable
  module ClassMethods
    def self.extended(base)
      base.instance_variable_set(:@attribute_set, AttributeSet.new)
    end

    # This will be invoked when a module with extended Attributable is
    # extended into a class or another module
    def extended(base)
      base.extend(Attributable) unless base.respond_to?(:extend_attributes)
      base.extend_attributes(attribute_set)
      if @module_plugins
        @module_plugins.each do |plugin_name|
          base.plugin plugin_name
        end
      end
    end

    def extend_attributes(attribute_set_to_extend)
      @attribute_set = attribute_set.merge(attribute_set_to_extend)
      @attribute_set.each do |name, atr|
        define_getter(atr)
        define_setter(atr)
      end
    end

    def inherited(base)
      base.instance_variable_set(:@attribute_set, attribute_set)
    end

    def attribute(name, klass, **args, &blk)
      @attribute_set = attribute_set.add(name, klass, **args, &blk)
      atr = @attribute_set[name]
      define_getter(atr)# unless args[:getter] == false
      define_setter(atr)# unless args[:setter] == false
    end

    def define_getter(atr)
      define_method(atr.getter_name) do
        instance_variable_get(atr.ivar_name)
      end
    end

    def define_setter(atr)
      define_method(atr.setter_name) do |val|
        instance_variable_set(atr.ivar_name, atr.set_with_plugins(val, self))
      end
    end

    def plugin(name)
      if self.class == Module
        # TEMP implementation. Needs to be tested and made imutable.
        @module_plugins ||= []
        @module_plugins << name
      else
        enable_plugin(name)
      end
    end

    def enable_plugin(name)
      begin
        plugin = Attributable.plugins.fetch(name)
      rescue KeyError
        raise "No plugin #{name} registered"
      end
      if mod = plugin.instance_methods_module
        self.include(mod)
      end
      if mod = plugin.class_methods_module
        self.extend(mod)
      end
    end

    def remove_plugins(*plugins)
      plugins.each do |atr|
        raise "Not implemented"
      end
    end

    alias remove_plugin remove_plugins

    def attributes(**kargs, &blk)
      BlockRunner.new(self).run(**kargs, &blk)
    end

    def remove_attributes(*atrs)
      atrs.each do |atr|
        @attribute_set = attribute_set.del(atr)
      end
    end

    alias remove_attribute remove_attributes

    def coerce(val, atr)
      new(val)
    end

    def attribute_set
      @attribute_set
    end
  end
end
