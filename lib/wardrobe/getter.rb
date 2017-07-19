module Wardrobe
  class Getter < Middleware
    def priority
      Wardrobe.getter_registery.priority(self)
    end
  end

  def self.register_getter(name:, before: [], after: [], getter:, use_if: ->(_atr) { true })
    getter_registery.register(Getter.new(name, getter, use_if), before, after)
  end

  Wardrobe.register_getter(
    name: :getter,
    getter: lambda do |_value, atr, instance|
      instance.instance_variable_get(atr.ivar_name)
    end
  )
end
