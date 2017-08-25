# frozen_string_literal: true

module Wardrobe
  class BlockSetup
    attr_reader :calling_klass, :block_options

    def initialize(calling_klass)
      @calling_klass = calling_klass
      @block_options = {}
    end

    def run(**kargs, &blk)
      if (karg = kargs.first)
        kargs.delete(karg.first)
        send(*karg) do
          run(**kargs, &blk)
        end
      else
        instance_exec(&blk)
      end
    end

    def attribute(name, klass, **keyargs, &blk)
      calling_klass.attribute(name, klass, **merged_options_for_attribute(keyargs), &blk)
    end

    def attributes(**kargs, &blk)
      run(**kargs, &blk)
    end

    def merged_options_for_attribute(args)
      result = args.dup
      block_options.map do |k, v|
        option = Wardrobe.options[k]
        result[k] = send("merge_#{option.klass_name}", result, k, v)
      end
      result
    end

    def merge_boolean(result, key, value)
      result[key] || value.last
    end

    def merge_set(result, key, value)
      convert_to_array_if_not_array(result, key)
      if result[key]
        Set.new(value.dup + result[key])
      else
        Set.new(value.dup)
      end
    end

    def merge_array(result, key, value)
      convert_to_array_if_not_array(result, key)
      if result[key]
        value.dup + result[key]
      else
        value.dup
      end
    end

    def merge_hash(result, key, value)
      if result[key]
        result[key].merge(value)
      else
        value.dup
      end
    end

    def convert_to_array_if_not_array(result, key)
      return unless result[key] && !result[key].is_a?(Array)
      result[key] = [result[key]]
    end

    class << self
      def register_option(option)
        # return if option.klass == Proc || option.klass == BasicObject
        send("create_#{option.klass_name}_method", option.name)
      rescue NoMethodError
        send("create_object_method", option.name)
        create_merge_method(option.klass_name)
      end

      def create_merge_method(klass_name)
        method_name = "merge_#{klass_name}"
        return if method_defined?(method_name)
        define_method(method_name) do |result, key, value|
          result[key] || value.last
        end
      end

      def create_array_method(name)
        define_method(name) do |*values, &blk|
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

      alias_method :create_set_method, :create_array_method

      def create_hash_method(name)
        define_method(name) do |**args, &blk|
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

      def create_boolean_method(name)
        define_method(name) do |val = true, &blk|
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

      def create_object_method(name)
        define_method(name) do |val, &blk|
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
    end
  end # class BlockSetup
end # module Wardrobe
