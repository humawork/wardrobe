module Atrs
  module Plugins
    module OptionalGetter
      extend Atrs::Plugin

      Atrs.register_getter(
        name: :optional_getter,
        priority: -100,
        use_if: ->(atr) { atr.options[:getter] == false },
        getter: ->(value, atr, instance) {
          raise NoMethodError.new("undefined method `#{atr.name}' for #{instance}")
        }
      )

      option :getter, Boolean, default: true, getter: :optional_getter
      
    end
  end
  register_plugin(:optional_getter, Plugins::OptionalGetter)
end
