module Atrs
  class Attribute
    using Coercions
    attr_reader :name, :klass, :options, :hooks

    def initialize(name, klass, **args, &blk)
      @name = name
      @klass = klass
      @options = {}
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
      klass.coerce(val, self)
    rescue Coercions::UnsupportedError
      raise Coercions::UnsupportedError, "Can't coerce #{val.class} `#{val}` into #{klass}"
    # rescue
    #   binding.pry
    end

    def merge(other)
      merged_options = options.dup
      other.options.each do |key, value|
        if merged_options[key]
          case value
          when Hash
            merged_options[key] = merged_options[key].merge(value)
          else
            binding.pry
          end
        else
          merged_options[key] = value.dup
        end
      end
      self.class.new(
        name,
        other.klass,
        merged_options
      )
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
        if plugin = Atrs.options[k]
          @options[k] = args[k]
          define_singleton_method(k) { @options[k] }
          add_plugin_hooks(plugin)
        else
          puts "WARN: option #{k} not supported"
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
