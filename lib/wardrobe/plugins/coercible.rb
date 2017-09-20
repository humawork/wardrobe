# frozen_string_literal: true

module Wardrobe
  register_setter(
    name: :coercer,
    before: [:setter],
    use_if: ->(atr) { atr.options[:coerce] },
    setter: lambda do |value, atr, instance, _options|
      begin
        Wardrobe::Coercible.coerce(value, to: atr.klass, parent: instance, atr: atr)
      rescue Wardrobe::Coercible::UnsupportedError => e
        raise e.class,
              "Can't coerce #{value.class} `#{value}` into #{atr.klass} for attribute `#{atr.name}` in class #{instance.class}."
      end
    end
  )

  module Plugins
    module Coercible
      extend Wardrobe::Plugin
      option :coerce, Boolean, default: true, setter: :coercer
    end
  end
  register_plugin(:coercible, Plugins::Coercible)
end
