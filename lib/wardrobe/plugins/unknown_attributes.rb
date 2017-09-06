# frozen_string_literal: true

module Wardrobe
  module Plugins
    module UnknownAttributes
      extend Wardrobe::Plugin

      class UnknownAttributesError < StandardError
        attr_reader :unknown_attributes
        def initialize(hash)
          @unknown_attributes = hash
        end
      end

      DEFAULT_CALLBACK = ->(attributes, instance) {
        raise UnknownAttributesError.new(attributes),
              attributes.keys.join(', ')
              # "Unknown attributes: #{attributes.keys.join(', ')}"
      }

      after_load do |klass, **args|
        if args[:callback] && !args[:callback].is_a?(Proc)
          raise MisconfiguredPluginError,
            "`callback` must be a Proc/lambda"
        end
      end

      module InstanceMethods
        private
        def _wardrobe_init(data)
          super
          unknown_attributes = data.keys - _attribute_store.store.keys
          if unknown_attributes.any?
            attributes = data.select { |k,v| unknown_attributes.include?(k) }
            callback = _plugin_store.dig(:unknown_attributes, :options, :callback)
            (callback || DEFAULT_CALLBACK).call(attributes, self)
          end
        end
      end
    end
  end
  register_plugin(:unknown_attributes, Plugins::UnknownAttributes)
end
