# frozen_string_literal: true

require_relative 'validation/refinements'
require_relative 'validation/validator'
require_relative 'validation/validation_error'

module Wardrobe
  module Plugins
    module Validation
      extend Wardrobe::Plugin
      option :validates, Hash

      class BlockHashCreator
        def initialize
          @result = {}
        end

        def call(&blk)
          instance_exec(&blk)
        end

        private

        def array?(&blk)
          call(&blk)
        end

        def min_size?(val, &blk)
          call(&blk)
        end

        def str?(&blk)
          call(&blk)
        end

        def each(&blk)
          call(&blk)
        end
      end

      module ClassMethods
        def validates(&blk)
          BlockHashCreator.new.call(&blk)
          # TODO: Create hash!
          # return { validates: { each: { length_min: 3 }} }
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
