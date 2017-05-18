# frozen_string_literal: true

module Wardrobe
  module Plugins
    module Validation
      module InstanceMethods
        def _validate
          unless _validated?
            @_validator = ValidationRunner.validate(self)
            @_validated = true
          end
          self
        end

        def _validate!
          _validate unless _validated?
          raise ValidationError.new(@_validator.errors) unless _valid?
          self
        end

        def _valid?
          _validate unless _validated?
          @_validator.errors.empty?
        end

        def _validation_errors
          _validate unless _validated?
          @_validator.errors
        end

        private

        def _validated?
          @_validated ||= false
        end
      end
    end
  end
end
