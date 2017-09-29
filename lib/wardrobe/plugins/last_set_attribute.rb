# frozen_string_literal: true

module Wardrobe
  module Plugins
    module LastSetAttribute
      extend Wardrobe::Plugin

      Wardrobe.register_setter(
        name: :last_set_attribute,
        before: [:setter],
        use_if: ->(atr) { atr.options[:use_last_set_attribute] },
        setter: lambda do |value, atr, instance, options|
          instance.instance_variable_set(:@_last_set_attribute, atr.name)
        end
      )

      option :use_last_set_attribute, Boolean, default: true, setter: :last_set_attribute

      module InstanceMethods
        def _last_set_attribute
          @_last_set_attribute ||= nil
        end
      end
    end
  end
  register_plugin(:last_set_attribute, Plugins::LastSetAttribute)
end
