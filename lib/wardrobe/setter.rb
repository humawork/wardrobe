module Wardrobe
  class Setter < Middleware
    def type
      :setter
    end

    def priority
      Wardrobe.setter_registery.priority(self)
    end
  end

  def self.register_setter(name:, before: [], after: [], setter:, use_if: ->(_atr) { true })
    setter_registery.register(Setter.new(name, setter, use_if), before, after)
  end

  Wardrobe.register_setter(
    name: :setter,
    setter: lambda do |value, atr, instance|
      instance.instance_variable_set(atr.ivar_name, value)
    end
  )
end
