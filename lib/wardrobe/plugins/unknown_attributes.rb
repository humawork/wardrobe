# frozen_string_literal: true

module Wardrobe
  module Plugins
    module UnknownAttributes
      extend Wardrobe::Plugin

      module InstanceMethods
        private
        def _wardrobe_init(data)
          super
          unknown_attributes = data.keys - _attribute_store.store.keys
          if unknown_attributes.any?
            self._wardrobe_config.plugin_store[:unknown_attributes][:options][:callback].call(
              data.select { |k,v| unknown_attributes.include?(k) }, self
            )
          end
        end
      end
    end
  end
  register_plugin(:unknown_attributes, Plugins::UnknownAttributes)
end
