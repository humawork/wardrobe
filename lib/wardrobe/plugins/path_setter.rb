# frozen_string_literal: true

module Wardrobe
  module Plugins
    module PathSetter
      extend Wardrobe::Plugin

      using Refinements::Path

      Wardrobe.register_setter(
        name: :path_setter,
        before: [:coercer, :setter],
        use_if: ->(atr) { atr.options[:path] },
        setter: lambda do |_value, atr, instance, _options|
          return _value unless instance._initializing?
          res = instance._initializing_hash.at(*atr.options[:path].split('/'))
          res.nil? ? _value : res
        end
      )

      option :path, String, setter: :path_setter
    end
  end
  register_plugin(:path_setter, Plugins::PathSetter)
end
