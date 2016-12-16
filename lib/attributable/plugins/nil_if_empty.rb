module Attributable
  module Plugins
    module NilIfEmpty
      extend Attributable::Plugin

      option :nil_if_empty, Boolean

      setter do |value, instance, arg|
        if arg.nil_if_empty
          case value
          when String, Array, Hash
            value unless value.empty?
          else
            value
          end
        else
          value
        end
      end
    end
  end
end
