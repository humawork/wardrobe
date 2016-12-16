module Attributable
  module Plugins
    module NilIfZero
      extend Attributable::Plugin

      option :nil_if_zero, Boolean

      setter do |value, instance, arg|
        if value == 0 && arg.nil_if_zero == true
          nil
        else
          value
        end
      end
    end
  end
end
