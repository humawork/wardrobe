module Atrs
  module Plugins
    module Default
      extend Atrs::Plugin

      Atrs.register_setter(
        name: :default_setter,
        priority: 5,
        use_if: ->(atr) { atr.options[:default] },
        setter: ->(value, atr, instance) {
          if value && ![{},[]].include?(value)
            value
          else
            default = atr.default
            case default
            when Symbol
              default.=~(/default$/) ? instance.send(default) : default
            when Proc
              default.arity == 0 ? default.call : default.call(instance)
            else
              default
            end
          end
        }
      )

      option :default, Boolean, setter: :default_setter
    end
  end
  register_plugin(:default, Plugins::Default)
end
