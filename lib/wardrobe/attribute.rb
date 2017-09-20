# frozen_string_literal: true

module Wardrobe
  class UnavailableOptionError < StandardError; end

  # Attribute class
  class Attribute
    attr_reader :name, :klass, :options, :ivar_name, :setter_name, :store,
                :setters, :getters

    def initialize(name, klass, defining_object, config, **options)
      @name = name
      @ivar_name = "@#{name}"
      @setter_name = "#{name}="
      @klass = validate_klass(klass)
      @options = {}
      create_option_methods(config)
      validate_and_coerce_options(options, config, defining_object)
      @getters ||= build_getter_array(defining_object)
      @setters ||= build_setter_array(defining_object)
      freeze
    end

    def merge(other, defining_object, config)
      merged_options = merge_options(other.options)
      self.class.new(name, other.klass, defining_object, config, merged_options)
    end

    def wardrobe?
      klass.respond_to?(:wardrobe_config)
    end

    private

    def validate_klass(klass)
      if klass.is_a?(Array) && klass.count != 1
        raise StandardError, %(
          `Array#{klass.map(&:name)}' contains two many classes.
          No more than one is allowed.
        )
      elsif klass.is_a?(Hash)
        # TODO: Validate hash
      end
      klass
    end

    def merge_options(other)
      merged_options = options.dup
      other.each do |key, value|
        next if merged_options[key] == value
        if merged_options[key]
          case value
          when Hash, Set
            merged_options[key] = merged_options[key].merge(value)
          else
            if value.respond_to?(:_wardrobe_config)
              if value._wardrobe_config.plugin_store[:merge]
                merged_options[key] = merged_options[key].merge(value)
              else
                raise "Unable to merge `#{value.class}`. Please add the `:merge` plugin."
              end
            else
              raise 'FIX ME! Currently only hash and set merge is supported'
            end
          end
        else
          merged_options[key] = value.dup
        end
      end
      merged_options
    end

    def build_getter_array(klass)
      (klass.option_store.values.map do |option|
        option.getter if option.use_getter_for_atr?(self)
      end + klass.default_getters).compact.sort
    end

    def build_setter_array(klass)
      (klass.option_store.values.map do |option|
        option.setter if option.use_setter_for_atr?(self)
      end + klass.default_setters).compact.sort
    end

    def create_option_methods(config)
      config.option_store.each do |option|
        define_singleton_method(option.name) do |&blk|
          if blk
            if options[option.name].nil? && option.options[:init]
              options[option.name] = option.options[:init].call(option, self)
            end
            blk.call(options[option.name])
          end
          options[option.name]
        end
        define_singleton_method("#{option.name}=") do |value|
          klass = config.option_store[option.name].klass
          if value.nil? && option.options[:coerce_if_nil] == false
            options[option.name] = nil
          else
            options[option.name] = begin
              Wardrobe::Coercible.coerce(value, to: klass, parent: self)
            rescue Wardrobe::Coercible::UnsupportedError => e
              if klass == Set
                Set.new([value])
              elsif klass == Array
                [value]
              else
                Wardrobe.logger.error "Can't coerce #{value.class} `#{value}` into #{klass}."
                raise e
              end
            end
          end
        end
      end
    end

    def validate_and_coerce_options(options, config, defining_object)
      config.option_store.each do |option|
        value = if options.has_key?(option.name)
                  options.delete(option.name)
                else
                  option.default_value
                end
        send("#{option.name}=", value)
      end

      options.keys.each do |name|
        Wardrobe.logger.error "Option '#{name}' is unavailable for attribute '#{self.name}' on '#{defining_object}'"
        raise UnavailableOptionError
      end
    end
  end
end
