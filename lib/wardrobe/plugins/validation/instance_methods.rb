# frozen_string_literal: true

module Wardrobe
  module Plugins
    module Validation
      module InstanceMethods
        def _validate
          return ValidationRunner.validate(self) if frozen?
          unless _validated?
            @_validator = ValidationRunner.validate(self)
            @_validated = true
          end
          @_validator
        end

        def _validate!
          validator = _validate
          raise ValidationError.new(validator.errors) unless validator.errors.empty?
          self
        end

        def _valid?
          _validate.errors.empty?
        end

        def _validation_errors
          _validate.errors
        end

        private

        def _validated?
          return false if frozen?
          @_validated ||= false
        end
      end
    end
  end
end
