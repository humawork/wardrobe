module Atrs
  module Plugins
    module NilIfEmpty
      extend Atrs::Plugin
      option :nil_if_empty, Boolean, setter: ->(value, atr, instance) do
        return value unless atr.nil_if_empty
        case value
        when String, Array, Hash
          value unless value.empty?
        else
          value
        end
      end
    end
  end
  register_plugin(:nil_if_empty, Plugins::NilIfEmpty)
end
