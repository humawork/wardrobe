# frozen_string_literal: true

module Wardrobe
  register_setter(
    name: :nil_if_zero,
    priority: 10,
    use_if: ->(atr) { atr.options[:nil_if_zero] },
    setter: lambda do |value, _atr, _instance|
      return value unless value == 0 || value == '0'
      nil
    end
  )
  module Plugins
    module NilIfZero
      extend Wardrobe::Plugin
      option :nil_if_zero, Boolean, setter: :nil_if_zero
    end
  end
  register_plugin(:nil_if_zero, Plugins::NilIfZero)
end
