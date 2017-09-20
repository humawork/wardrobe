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
          options[:path] ||= []
          options[:path] << self
          result = {}
          # TODO: Optimize!
          _attribute_store.store.each do |key, atr|
            if attributes.nil? || (attributes && attributes.key?(key))
              value = send(atr.name)._present(attributes: (attributes[key] if attributes), **options)
              if options[:remove_if_empty] && value.respond_to?(:empty?) && value.empty?
                next unless attributes && attributes.dig(key, :_, :present_if_empty)
              end
              unless value.nil? && options[:remove_if_nil]
                arr = [key]
                if attributes && override_proc = attributes.dig(key, :_, :key_override)
                  arr[0] = override_proc.call(self, atr, attributes, **options)
                end
                if attributes && path = attributes.dig(key, :_, :pre_path)
                  arr.unshift(*path)
                end
                result._set_at(value, arr)
              end
            end
          end
          result
        ensure
          options[:path].pop
        end
      end
    end
  end
  register_plugin(:presenter, Plugins::Presenter)
end
