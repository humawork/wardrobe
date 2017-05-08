# frozen_string_literal: true

module Atrs
  register_setter(
    name: :nil_if_zero,
    priority: 10,
    use_if: ->(atr) { atr.options[:nil_if_zero] },
    setter: lambda do |value, _atr, _instance|
      value == 0 ? nil : value
    end
  )
  module Plugins
    module NilIfZero
      extend Atrs::Plugin
      option :nil_if_zero, Boolean, setter: :nil_if_zero
    end
  end
  register_plugin(:nil_if_zero, Plugins::NilIfZero)
end
