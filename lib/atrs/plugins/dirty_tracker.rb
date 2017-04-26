# frozen_string_literal: true

module Atrs
  module Plugins
    module DirtyTracker
      extend Atrs::Plugin

      Atrs.register_setter(
        name: :dirty_tracker,
        priority: 25,
        use_if: ->(atr) { atr.options[:track] },
        setter: lambda do |value, atr, instance|
          return value if instance._initializing?
          instance._dirty! if value != instance.instance_variable_get(atr.ivar_name)
          value
        end
      )

      Atrs.register_getter(
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
            if val == :atrs_instance
              _dirty! if instance_variable_get(atr.ivar_name)._changed?
            else
              _dirty! if instance_variable_get(atr.ivar_name).hash != val
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
                                         :atrs_instance
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
