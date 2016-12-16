module Attributable
  module Plugins
    module DefaultValue
      extend Attributable::Plugin

      option :default, Boolean

      setter do |value, instance, arg|
        return value if value
        default = arg.default
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
