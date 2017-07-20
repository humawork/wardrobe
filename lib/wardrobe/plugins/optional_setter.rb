# frozen_string_literal: true

module Wardrobe
  module Plugins
    module OptionalSetter
      extend Wardrobe::Plugin

      Wardrobe.register_setter(
        name: :optional_setter,
        before: [:setter],
        use_if: ->(atr) { atr.options[:setter] == false },
        setter: lambda do |_value, atr, instance, _options|
          return _value if instance._initializing?
          raise NoMethodError, "undefined method `#{atr.name}=' for #{instance}"
        end
      )

      option :setter, Boolean, default: true, setter: :optional_setter
    end
  end
  register_plugin(:optional_setter, Plugins::OptionalSetter)
end
