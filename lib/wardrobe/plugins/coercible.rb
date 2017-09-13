# frozen_string_literal: true

module Wardrobe
  class Attribute
    using Refinements::Coercible

    def _coerce(val, parent)
      klass.coerce(val, self, parent)
    rescue Refinements::Coercible::UnsupportedError => e
      raise e.class,
            "Can't coerce #{val.class} `#{val}` into #{klass}."
    end
  end

  register_setter(
    name: :coercer,
    before: [:setter],
    use_if: ->(atr) { atr.options[:coerce] },
    setter: lambda do |value, atr, instance, _options|
      atr._coerce(value, instance)
    end
  )

  module Plugins
    module Coercible
      extend Wardrobe::Plugin
      option :coerce, Boolean, default: true, setter: :coercer

      module ClassMethods
        def coerce(val, _atr, _parent)
          return new if val.nil?
          return new(**val) if val.is_a?(Hash)
          return val if val.class == self
          new(val)
        end
      end
    end
  end
  register_plugin(:coercible, Plugins::Coercible)
end
