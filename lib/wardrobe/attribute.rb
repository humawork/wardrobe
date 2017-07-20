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
      @options = validate_options(options, config, defining_object)
      @getters ||= build_getter_array(defining_object)
      @setters ||= build_setter_array(defining_object)
      freeze
    end

    def merge(other, defining_object, config)
      merged_options = merge_options(other.options)
      self.class.new(name, other.klass, defining_object, config, merged_options)
    end

    def wardrobe?
      klass.respond_to?(:wardrobe_stores)
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
          raise 'FIX ME! Currently only hash merge is supported' unless value.is_a?(Hash)
          merged_options[key] = merged_options[key].merge(value)
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

    def validate_options(options, config, defining_object)
      options.each do |name, _|
        unless config.option_store[name]
          Wardrobe.logger.error "Option '#{name}' is unavailable for attribute '#{self.name}' on '#{defining_object}'"
          raise UnavailableOptionError
        end
      end
    end
  end
end
