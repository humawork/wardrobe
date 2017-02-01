module Atrs
  module Plugins
    module NilIfZero
      extend Atrs::Plugin
      option :nil_if_zero, Boolean, setter: ->(value, atr, instance) do
        if value == 0 && atr.nil_if_zero == true
          nil
        else
          value
        end
      end
    end
  end
  register_plugin(:nil_if_zero, Plugins::NilIfZero)
end
