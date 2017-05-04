# frozen_string_literal: true

module Atrs
  module Plugins
    module NilIfEmpty
      extend Atrs::Plugin

      Atrs.register_setter(
        name: :nil_if_empty,
        priority: 20,
        use_if: ->(atr) { atr.options[:nil_if_empty] },
        setter: lambda do |value, atr, _instance|
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
