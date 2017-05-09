# frozen_string_literal: true

module Wardrobe
  class BlockSetup
    attr_reader :calling_klass, :block_options

    def initialize(calling_klass)
      @calling_klass = calling_klass
      # TODO: Refactor!!!
      calling_klass.plugin_store.each do |key, value|
        value[:klass].options.each do |option|
          case
          when option.klass == Boolean
            define_boolean_method(option.name)
          when option.klass == Array
            define_array_method(option.name)
          when option.klass == Set
            define_array_method(option.name)
          when option.klass == Hash
            define_hash_method(option.name)
          else
            raise "Unsupported plugin class: #{option.klass}"
          end
        end
      end
      @block_options = {}
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
    rescue NoMethodError => e
      if karg
        puts "Option #{karg.first} is not a valid option."
        if (option = Wardrobe.options[karg.first])
          if (name = Wardrobe.plugins.key(option.plugin))
            puts "  enable the plugin `#{name}` to enable this option"
          end
        end
      end
      raise e
    end

    def attribute(name, klass, **keyargs, &blk)
      calling_klass.attribute(name, klass, **merged_options_for_attribute(keyargs), &blk)
    end

    def attributes(**kargs, &blk)
      run(**kargs, &blk)
    end

    def merged_options_for_attribute(args)
      result = args.dup
      block_options.map do |key, value|
        case
        when Wardrobe.options[key].klass == Boolean
          result[key] = value.last unless result[key]
        when Wardrobe.options[key].klass == Set
          if result[key] && !result[key].is_a?(Array)
            result[key] = [result[key]]
          end
          result[key] = if result[key]
                          Set.new(value.dup + result[key])
                        else
                          Set.new(value.dup)
                        end
        when Wardrobe.options[key].klass == Array
          if result[key] && !result[key].is_a?(Array)
            result[key] = [result[key]]
          end
          result[key] = if result[key]
                          value.dup + result[key]
                        else
                          value.dup
                        end
        when Wardrobe.options[key].klass == Hash
          result[key] = if result[key]
                          result[key].merge(value)
                        else
                          value.dup
                        end
        else
          raise 'Unsupported BlockSetup class'
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

    def define_array_method(name)
      define_singleton_method(name) do |*values, &blk|
        begin
          block_options[name] ||= []
          block_options[name].push(*values)
          instance_exec(&blk) if blk || block_given?
        ensure
          block_options[name].pop(values.length)
          block_options.delete(name) if block_options[name].empty?
        end
      end
    end

    def define_hash_method(name)
      define_singleton_method(name) do |**args, &blk|
        begin
          block_options[name] ||= {}
          block_options[name].merge!(args)
          instance_exec(&blk) if blk || block_given?
        ensure
          args.keys.map { |key| block_options[name].delete(key) }
          block_options.delete(name) if block_options[name].empty?
        end
      end
    end

    def define_boolean_method(name)
      define_singleton_method(name) do |val = true, &blk|
        begin
          block_options[name] ||= []
          block_options[name] << val
          instance_exec(&blk) if blk || block_given?
        ensure
          block_options[name].pop
          block_options.delete(name) if block_options[name].empty?
        end
      end
    end
  end # class BlockSetup
end # module Wardrobe
