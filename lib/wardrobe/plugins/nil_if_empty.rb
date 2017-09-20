# frozen_string_literal: true

module Wardrobe
  module Plugins
    module NilIfEmpty
      extend Wardrobe::Plugin

      Wardrobe.register_setter(
        name: :nil_if_empty,
        before: [:setter],
        after: [:coercer],
        use_if: ->(atr) { atr.options[:nil_if_empty] },
        setter: lambda do |value, atr, _instance, _options|
          return value unless atr.options[:nil_if_empty]
          case value
          when String, Array, Hash
            value unless value.empty?
          else
            value
          end
        end
      )

      option :nil_if_empty, Boolean, setter: :nil_if_empty
    end
  end
  register_plugin(:nil_if_empty, Plugins::NilIfEmpty)
end
