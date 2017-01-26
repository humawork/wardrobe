module Atrs
  module Plugins
    module NilIfZero
      extend Atrs::Plugin

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
