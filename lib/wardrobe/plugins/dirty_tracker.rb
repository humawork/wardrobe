# frozen_string_literal: true

module Wardrobe
  module Plugins
    module DirtyTracker
      extend Wardrobe::Plugin

      Wardrobe.register_setter(
        name: :dirty_tracker,
        priority: 25,
        use_if: ->(atr) { atr.options[:track] },
        setter: lambda do |value, atr, instance|
          return value if instance._initializing?
          instance._dirty! if value != instance._get_attribute_value(atr)
          value
        end
      )

      Wardrobe.register_getter(
        name: :dirty_tracker,
        priority: 5,
        use_if: ->(atr) { atr.options[:track] },
        getter: lambda do |value, atr, instance|
          instance._register_get(atr, value)
          value
        end
      )

      option :track, Boolean, default: true, setter: :dirty_tracker,
             getter: :dirty_tracker#setter(10,&setter_proc)

      module InstanceMethods
        def _changed?
          _fetched_attributes.delete_if do |atr, val|
            if val == :wardrobe_instance
              _dirty! if _get_attribute_value(atr)._changed?
            else
              _dirty! if _get_attribute_value(atr).hash != val
            end
            true
          end
          @changed ||= false
        end

        def _dirty!
          @changed = true
        end

        def _register_get(atr, value)
          _fetched_attributes[atr] ||= if value.respond_to?(:_changed?)
                                         :wardrobe_instance
                                       else
                                         value.hash
                                       end
        end

        private

        def _fetched_attributes
          @_fetched_attributes ||= {}
        end
      end
    end
  end
  register_plugin(:dirty_tracker, Plugins::DirtyTracker)
end
