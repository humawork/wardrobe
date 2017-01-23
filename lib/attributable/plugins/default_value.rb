module Attributable
  module Plugins
    module DefaultValue
      extend Attributable::Plugin

      option :default, Boolean

      #TODO: Find a way to make to get rid of setter concept...

      setter do |value, instance, arg|
        if value && ![{},[]].include?(value)
          value
        else
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
end
