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
          res = nil
          path_option = atr.options[:path]
          if path_option.instance_of?(String)
            res = instance._initializing_hash.at(*path_option.split('/'))
          elsif path_option.instance_of?(Array)
            path_option.each{|path|
              if res = instance._initializing_hash.at(*path.split('/'))
                break
              end
            }
          end
            res.nil? ? _value : res
        end
      )

      option :path, BasicObject, setter: :path_setter
    end
  end
  register_plugin(:path_setter, Plugins::PathSetter)
end
