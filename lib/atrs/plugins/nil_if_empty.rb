module Atrs
  module Plugins
    module NilIfEmpty
      extend Atrs::Plugin

      Atrs.register_setter(
        name: :nil_if_empty,
        priority: 20,
        use_if: ->(atr) { atr.options[:nil_if_empty] },
        setter: ->(value, atr, instance) {
          return value unless atr.nil_if_empty
          case value
          when String, Array, Hash
            value unless value.empty?
          else
            value
          end
        }
      )

      option :nil_if_empty, Boolean, setter: :nil_if_empty
      # use_if: ->(atr) { binding.pry }, setter: setter(10) { |value, atr, instance|
      #   return value unless atr.nil_if_empty
      #   case value
      #   when String, Array, Hash
      #     value unless value.empty?
      #   else
      #     value
      #   end
      # }
    end
  end
  register_plugin(:nil_if_empty, Plugins::NilIfEmpty)
end
