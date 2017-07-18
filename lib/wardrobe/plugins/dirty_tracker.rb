# frozen_string_literal: true

module Wardrobe
  module Plugins
    module DirtyTracker
      extend Wardrobe::Plugin

      # TODO: This plugin needs a major cleanup!

      Wardrobe.register_setter(
        name: :dirty_tracker,
        before: [:setter],
        use_if: ->(atr) { atr.options[:track] },
        setter: lambda do |value, atr, instance|
          return value if instance._initializing?
          instance._dirty! if value != instance._get_attribute_value(atr)
          value
        end
      )

      Wardrobe.register_getter(
        name: :dirty_tracker,
        after: [:getter],
        use_if: ->(atr) { atr.options[:track] },
        getter: lambda do |value, atr, instance|
          return value if instance._initializing?
          instance._register_get(atr.name, value)
          value
        end
      )

      option :track, Boolean, default: true, setter: :dirty_tracker,
             getter: :dirty_tracker

      module InstanceMethods
        def _changed?
          _fetched_attributes.delete_if do |atr, ref|
            value = _get_attribute_value(atr)
            _dirty! if _value_changed?(value, ref)
            true
          end
          @_dirty_tracker_changed ||= false
        end

        def _value_changed?(value, ref)
          if ref == :wardrobe_instance
            if value._changed?
              _dirty!
              _dirty_tracker_dirty_sub_instances << value
            end
          elsif ref.is_a? Array
            _dirty! if value.hash != ref.first
            value.each.with_index.any? do |item, index|
              _value_changed?(item, ref.last[index])
            end
          elsif ref.is_a? Hash
            _dirty! if value.hash != ref[:hash]
            value.any? do |k,v|
              if value.has_value?(v)
                changed_value = _value_changed?(v, ref[:values][v])
              end
              if value.has_key?(k)
                changed_key = _value_changed?(k, ref[:keys][k])
              end
              changed_value || changed_key
            end
          else
            _dirty! if value.hash != ref
          end
        end

        alias :_dirty? :_changed?

        def _reset_dirty_tracker!
          @_fetched_attributes = {}
          _dirty_tracker_dirty_sub_instances.map(&:_reset_dirty_tracker!)
          @_dirty_tracker_changed = false
          remove_instance_variable(:@_dirty_tracker_dirty_sub_instances)
          nil
        end

        def _dirty_tracker_dirty_sub_instances
          @_dirty_tracker_dirty_sub_instances ||= Set.new
        end

        def _dirty!
          @_dirty_tracker_changed = true
        end

        def _register_get(atr, value)
          _fetched_attributes[atr] ||= _find_ref(value)
        end

        def _find_ref(value)
          if value.respond_to?(:_changed?)
            :wardrobe_instance
          elsif value.is_a?(Array)
            [value.hash, value.map { |item| _find_ref(item) }]
          elsif value.is_a?(Hash)
            res = { keys: {}, values: {}, hash: value.hash}
            value.each do |k,v|
              res[:keys][k] = _find_ref(k)
              res[:values][v] = _find_ref(v)
            end
            res
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
