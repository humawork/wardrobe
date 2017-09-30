# frozen_string_literal: true

require 'wardrobe/refinements/presenter'

module Wardrobe
  module Plugins
    module Presenter
      extend Wardrobe::Plugin

      module InstanceMethods
        using Refinements::Presenter
        def _present(attributes: nil, **args)
          options = self.class.plugin_store[:presenter][:options].merge(args)
          result = {}
          # TODO: Optimize!
          _attribute_store.store.each do |key, atr|
            if attributes.nil? || (attributes && attributes.key?(key))
              if attributes
                child_attributes = attributes[key]
                present_overrides = child_attributes&.dig(:_)
              end

              if before_hooks = present_overrides&.dig(:hooks, :before_present)
                before_hooks.each do |hook|
                  hook.call(atr, options, self, result)
                end
              end

              value = send(atr.name)._present(attributes: child_attributes, **options)

              if options[:remove_if_empty] && value.respond_to?(:empty?) && value.empty?
                next unless present_overrides&.dig(:present_if_empty)
              end

              unless value.nil? && options[:remove_if_nil]
                if present_overrides
                  arr = [key]
                  if override_proc = present_overrides&.dig(:key_override)
                    arr[0] = override_proc.call(self, atr, attributes, **options)
                  end
                  if path = present_overrides&.dig(:pre_path)
                    arr.unshift(*path)
                  end
                  result._set_at(value, arr)
                else
                  result[key] = value
                end
              end

              if after_hooks = present_overrides&.dig(:hooks, :after_present)
                after_hooks.each do |hook|
                  hook.call(atr, options, self, result)
                end
              end
            end
          end
          result
        end
      end
    end
  end
  register_plugin(:presenter, Plugins::Presenter)
end
