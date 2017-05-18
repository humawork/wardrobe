module Wardrobe
  class << self
    attr_reader :setters, :getters
  end
  @setters = {}
  @getters = {}

  class SetterGetter
    attr_reader :name, :priority, :block, :use_if

    def initialize(name, priority, block, use_if)
      @name = name
      @priority = priority
      @block = block
      @use_if = use_if
    end

    def <=>(other)
      priority <=> other.priority
    end
  end

  def self.register_setter(name:, priority:, setter:, use_if: ->(_atr) { true })
    raise 'Name taken' if setters[name]
    setters[name] = SetterGetter.new(name, priority, setter, use_if)
  end

  def self.register_getter(name:, priority:, getter:, use_if: ->(_atr) { true })
    raise 'Name taken' if getters[name]
    getters[name] = SetterGetter.new(name, priority, getter, use_if)
  end

  Wardrobe.register_getter(
    name: :getter,
    priority: 0,
    getter: lambda do |_value, atr, instance|
      instance.instance_variable_get(atr.ivar_name)
    end
  )

  Wardrobe.register_setter(
    name: :setter,
    priority: 100,
    setter: lambda do |value, atr, instance|
      instance.instance_variable_set(atr.ivar_name, value)
    end
  )
end
