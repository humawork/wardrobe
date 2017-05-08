# frozen_string_literal: true

module Wardrobe
  module Plugins
    module OptionalSetter
      extend Wardrobe::Plugin

      option :setter, Boolean, default: true

      module InstanceMethods
        def _attribute_init(atr, hash, name)
          super unless atr.respond_to?(:setter) && atr.setter == false
        end
      end

      module ClassMethods
        def define_setter(atr)
          super unless atr.respond_to?(:setter) && atr.setter == false
        end
      end
    end
  end
  register_plugin(:optional_setter, Plugins::OptionalSetter)
end
