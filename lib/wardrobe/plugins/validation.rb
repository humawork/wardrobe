# frozen_string_literal: true

require_relative 'validation/refinements'
require_relative 'validation/validator'
require_relative 'validation/validation_error'
require_relative 'validation/block_handler'

# TODO:
# - Setting to run validations automatically
# - Support all Hanami/Dry validations
# - Support advanced predicates




module Wardrobe
  module Plugins
    module Validation
      extend Wardrobe::Plugin
      option :validates, Hash

      module ClassMethods
        def validates(&blk)
          { validates: BlockHandler.new(&blk).result }
        end
      end

      module InstanceMethods
        def _validate
          unless _validated?
            @_validator = Validator.validate(self)
            @_validated = true
          end
          self
        end

        def _validate!
          _validate unless _validated?
          raise ValidationError.new(_validation_errors_hash) unless _valid?
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
  register_plugin(:validation, Plugins::Validation)
end
