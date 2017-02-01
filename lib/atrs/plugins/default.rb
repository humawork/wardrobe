module Atrs
  module Plugins
    module Default
      extend Atrs::Plugin

      option :default, Boolean, setter: ->(value, atr, instance) do
        if value && ![{},[]].include?(value)
          value
        else
          default = atr.default
          case default
          when Symbol then instance.send(default)
          when Proc
            default.arity == 0 ? default.call : default.call(instance)
          else
            default
          end
        end
      end
    end
  end
  register_plugin(:default, Plugins::Default)
end
