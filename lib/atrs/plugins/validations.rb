require_relative 'validations/refinements/integer'
require_relative 'validations/refinements/string'
require_relative 'validations/refinements/nil_class'
require_relative 'validations/refinements/object'
require_relative 'validations/validator'

module Atrs
  module Plugins
    module Validations
      class ValidationError < StandardError

        attr_reader :errors

        def initialize(errors)
          @errors = errors.freeze
        end
      end

      extend Atrs::Plugin
      option :validates, Hash

      module InstanceMethods
        def _validate
          unless _validated?
            Validator.new(self).run
            @_validated = true
          end
          self
        end

        def _validate!
          _validate unless _validated?
          raise ValidationError.new(_validation_errors) unless _valid?
          self
        end

        def _valid?
          _validate unless _validated?
          _validation_errors.empty?
        end

        def _validation_errors
          @_validation_errors ||= Hash.new do |hash,key|
            hash[key] = []
          end
        end

        private

        def _validated?
          @_validated ||= false
        end
      end

    end
  end
  register_plugin(:validations, Plugins::Validations)
end
