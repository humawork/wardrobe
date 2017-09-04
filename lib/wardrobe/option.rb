# frozen_string_literal: true

module Wardrobe
  class Option
    attr_reader :name, :klass, :plugin, :default, :options, :setter, :getter

    def initialize(name, klass, plugin, **kargs)
      @name = name
      @klass = klass
      @plugin = plugin
      @default = kargs.fetch(:default, nil)
      @getter = Wardrobe.getters[kargs.fetch(:getter, nil)]
      @setter = Wardrobe.setters[kargs.fetch(:setter, nil)]
      @options = kargs
      freeze
    end

    def default_value
      if options.has_key?(:default)
        options[:default].is_a?(Proc) ? options[:default].call : options[:default]
      end
    end

    def klass_name
      klass.to_s[/([^:]+)$/,1].downcase
    end

    def use_getter_for_atr?(atr)
      getter&.use_if&.call(atr)
    end

    def use_setter_for_atr?(atr)
      setter&.use_if&.call(atr)
    end
  end
end
