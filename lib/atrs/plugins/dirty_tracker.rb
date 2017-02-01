module Atrs
  module Plugins
    module DirtyTracker
      extend Atrs::Plugin

      option :track, Boolean, default: true,
        setter: ->(value, atr, instance) do
          return value unless instance.initialized?
          instance.dirty! if value != instance.instance_variable_get(atr.ivar_name)
          value
        end

      module ClassMethods
        def define_getter(atr)
          define_method(atr.name) do
            value = instance_variable_get(atr.ivar_name)
            _fetched_attributes[atr] ||= if value.respond_to?(:changed?)
                                           :changed?
                                         else
                                           value.hash
                                         end
            value
          end
        end
      end

      module InstanceMethods
        def changed?
          _fetched_attributes.delete_if do |atr, val|
            if val == :changed?
              dirty! if instance_variable_get(atr.ivar_name).changed?
            else
              dirty! if instance_variable_get(atr.ivar_name).hash != val
            end
            true
          end
          @changed ||= false
        end

        def dirty!
          @changed = true
        end

        private

        def _fetched_attributes
          @_fetched_attributes ||= Hash.new
        end
      end
    end
  end
  register_plugin(:dirty_tracker, Plugins::DirtyTracker)
end
