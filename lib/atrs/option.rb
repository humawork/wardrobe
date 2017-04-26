# frozen_string_literal: true

module Atrs
  class Option
    attr_reader :name, :klass, :plugin, :default, :options, :setter, :getter

    def initialize(name, klass, plugin, **kargs, &blk)
      @name = name
      @klass = klass
      @plugin = plugin
      @default = kargs.fetch(:default, nil)
      @getter = Atrs.getters[kargs.fetch(:getter, nil)]
      @setter = Atrs.setters[kargs.fetch(:setter, nil)]
      @options = kargs
      freeze
    end

    def use_getter_for_atr?(atr)
      getter&.use_if&.call(atr)
    end

    def use_setter_for_atr?(atr)
      setter&.use_if&.call(atr)
    end
  end
end
