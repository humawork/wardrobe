module Atrs
  class Attribute
    using Coercions
    attr_reader :name, :klass, :options, :ivar_name, :setter_name

    def initialize(name, klass, defining_klass, **args, &blk)
      @name = name
      @ivar_name = "@#{name}"
      @setter_name = "#{name}="
      @klass = klass
      @options = {}
      set_valid_options(defining_klass, **args)
      setter_name
      freeze
    end

    def coerce(val)
      klass.coerce(val, self)
    rescue Coercions::UnsupportedError
      raise Coercions::UnsupportedError, "Can't coerce #{val.class} `#{val}` into #{klass}"
    end

    def merge(other, defining_klass)
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
        defining_klass,
        merged_options
      )
    end

    private

    def set_valid_options(defining_klass, **args)
      args.each do |name, value|
        if defining_klass.option_set[name]
          puts name
          # if name == :alias_setter
          #   binding.pry
          # end
          @options[name] = args[name]
          define_singleton_method(name) { @options[name] }
        else
          raise "ERROR: option #{name} not available on #{defining_klass}"
        end
      end
    end
  end
end
