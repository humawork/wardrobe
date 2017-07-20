# frozen_string_literal: true

module Wardrobe
  module Plugins
    module EditCallback
      extend Wardrobe::Plugin

      Wardrobe.register_setter(
        name: :edited,
        before: [:setter],
        use_if: ->(atr) { atr.options[:edited] },
        setter: lambda do |value, atr, instance, options|
          if value != instance.send(atr.name)
            atr.options[:edited].call(instance.send(atr.name), value, atr, instance)
          end
        end
      )

      option :edited, Proc, setter: :edited
    end
  end
  register_plugin(:edit_callback, Plugins::EditCallback)
end
