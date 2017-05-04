# frozen_string_literal: true

module Atrs
  class Attribute
    using Coercions

    def coerce(val)
      klass.coerce(val, self)
    rescue Coercions::UnsupportedError
      raise Coercions::UnsupportedError,
            "Can't coerce #{val.class} `#{val}` into #{klass}"
    end
  end

  register_setter(
    name: :coercer,
    priority: -100,
    use_if: ->(_atr) { true },
    setter: lambda do |value, atr, _instance|
      atr.coerce(value)
    end
  )

  module Plugins
    module Coercible
      extend Atrs::Plugin
      option :coerce, Boolean, default: true, setter: :coercer

      module ClassMethods
        def coerce(val, _atr)
          return new if val.nil?
          new(**val)
        end
      end
    end
  end
  register_plugin(:coercible, Plugins::Coercible)
end
