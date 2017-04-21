module Atrs
  class Option
    attr_reader :name, :klass, :plugin, :default, :options, :setter, :getter

    def initialize(name, klass, plugin, default: nil, setter: nil, getter: nil, **kargs, &blk)
      @name = name
      @klass = klass
      @plugin = plugin
      @default = default
      @getter = Atrs.getters[getter]
      @setter = Atrs.setters[setter]
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
