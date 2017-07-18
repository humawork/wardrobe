# frozen_string_literal: true

module Wardrobe
  module Plugins
    module OptionalGetter
      extend Wardrobe::Plugin

      Wardrobe.register_getter(
        name: :optional_getter,
        before: [:getter],
        use_if: ->(atr) { atr.options[:getter] == false },
        getter: lambda do |_value, atr, instance|
          raise NoMethodError, "undefined method `#{atr.name}' for #{instance}"
        end
      )

      option :getter, Boolean, default: true, getter: :optional_getter
    end
  end
  register_plugin(:optional_getter, Plugins::OptionalGetter)
end
