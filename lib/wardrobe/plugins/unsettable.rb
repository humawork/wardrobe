# frozen_string_literal: true

module Wardrobe
  module Plugins
    module Unsettable
      extend Wardrobe::Plugin

      module InstanceMethods
        def _attribute_init(atr, hash)
          super unless atr.options[:unsettable]
        end
      end

      module ClassMethods
        def define_setter(atr)
          super unless atr.options[:unsettable]
        end
        def define_getter(atr)
          super unless atr.options[:unsettable]
        end
      end

      option :unsettable, Boolean, default: false
    end
  end
  register_plugin(:unsettable, Plugins::Unsettable)
end
