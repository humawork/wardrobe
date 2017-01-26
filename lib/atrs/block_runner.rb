module Atrs
  class BlockRunner
    attr_reader :calling_klass, :options

    def initialize(calling_klass)
      @calling_klass = calling_klass
      @options = {}
    end

    def run(**kargs, &blk)
      if karg = kargs.first
        kargs.delete(karg.first)
        send(*karg) do
          run(**kargs, &blk)
        end
      else
        instance_exec(&blk)
      end
    end

    def attribute(name, klass, **args, &blk)
      calling_klass.attribute(name, klass, **merged_options_for_attribute(args), &blk)
    end

    def attributes(**kargs, &blk)
      run(**kargs, &blk)
    end

    def merged_options_for_attribute(args)
      result = args.dup
      options.map do |key, value|
        case
        when self.class.plugins[key] == Boolean
          result[key] = value.last unless result[key]
        when self.class.plugins[key] == Array
          result[key] = if result[key]
                          value.dup + result[key]
                        else
                          value.dup
                        end
        when self.class.plugins[key] == Hash
          result[key] = if result[key]
                          result[key].merge(value)
                        else
                          value.dup
                        end
        else
          binding.pry
        end
      end
      result
    end

    def self.plugins
      @plugins ||= {}
    end

    def self.add_plugin(plugin)
      option_klass = plugin.option_klass
      option_name = plugin.option_name
      plugins[option_name] = option_klass
      case
      when option_klass == Boolean
        define_boolean_method(option_name)
      when option_klass == Array
        define_array_method(option_name)
      when option_klass == Hash
        define_hash_method(option_name)
      else
        raise "Unsupported plugin class: #{option_klass}"
      end
    end

    def self.define_array_method(name)
      define_method(name) do |*values, &blk|
        begin
          options[name] ||= []
          options[name].push(*values)
          instance_exec(&blk) if blk || block_given?
        ensure
          options[name].pop(values.length)
          options.delete(name) if options[name].empty?
        end
      end
    end

    def self.define_hash_method(name)
      define_method(name) do |**args, &blk|
        begin
          options[name] ||= {}
          options[name].merge!(args)
          instance_exec(&blk) if blk || block_given?
        ensure
          args.keys.map { |key| options[name].delete(key) }
          options.delete(name) if options[name].empty?
        end
      end
    end

    def self.define_boolean_method(name)
      define_method(name) do |val = true, &blk|
        begin
          options[name] ||= []
          options[name] << val
          instance_exec(&blk) if blk || block_given?
        ensure
          options[name].pop
          options.delete(name) if options[name].empty?
        end
      end
    end
  end # class BlockRunner
end # module Atrs
