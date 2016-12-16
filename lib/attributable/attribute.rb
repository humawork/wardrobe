module Attributable
  class Attribute
    using Coercions
    attr_reader :name, :klass, :hooks

    def initialize(name, klass, **args, &blk)
      @name = name
      @klass = klass
      @hooks = {
        setter: []
      }
      set_valid_options(**args)
      freeze
    end


    def set_with_plugins(val, instance)
      return val unless setter_hooks.any?
      setter_hooks.each do |hook|
        val = hook.call(val, instance, self)
      end
      val
    end

    def coerce(val)
      klass.coerce(val)
    end

    def getter_name
      name
    end

    def ivar_name
      "@#{name}"
    end

    def setter_name
      "#{name}="
    end

    private

    def setter_hooks
      hooks[:setter]
    end

    def set_valid_options(**args)
      args.each do |k,v|
        if plugin = Attributable.options[k]
          instance_variable_set("@#{k}", args.delete(k))
          define_singleton_method(k) { instance_variable_get("@#{k}") }
          add_plugin_hooks(plugin)
        end
      end
    end

    def add_plugin_hooks(plugin)
      if hook = plugin.setter
        setter_hooks << hook
      end
    end
  end
end
