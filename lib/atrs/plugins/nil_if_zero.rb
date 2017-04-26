# frozen_string_literal: true

module Atrs
  module Plugins
    module NilIfZero
      extend Atrs::Plugin

      Atrs.register_setter(
        name: :nil_if_zero,
        priority: 10,
        use_if: ->(atr) { atr.options[:nil_if_zero] },
        setter: lambda do |value, _atr, _instance|
          value == 0 ? nil : value
        end
      )

      option :nil_if_zero, Boolean, setter: :nil_if_zero
      # setter(10) { |value, atr, instance|
      #   if value == 0 && atr.nil_if_zero == true
      #     nil
      #   else
      #     value
      #   end
      # }
    end
  end
  register_plugin(:nil_if_zero, Plugins::NilIfZero)
end
