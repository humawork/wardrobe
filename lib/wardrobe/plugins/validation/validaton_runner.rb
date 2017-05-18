# frozen_string_literal: true

module Wardrobe
  module Plugins
    module Validation
      class ValidationRunner
        attr_reader :instance

        def initialize(instance)
          @instance = instance
        end

        def self.validate(instance)
          new(instance).run
        end

        def Validate(value, atr, error_store)
          Validator.new(value, atr, error_store).run
        end

        def run
          instance._attribute_store.each do |name, atr|
            Validate(instance.send(atr.name), atr, error_store)
          end
          self
        end

        def error_store
          @error_store ||= ErrorStore.new
        end

        def errors
          error_store.store
        end
      end
    end
  end
end
