require_relative 'validate/validations/integer'
require_relative 'validate/validations/string'
require_relative 'validate/validator'

module Attributable
  module Plugins
    module Validate
      extend Attributable::Plugin
      option :validate, Hash
      option :required, Boolean

      module InstanceMethods
        def _validate!
          Validator.new(self).run
          self
        end

        def _valid?
          _validate! unless _validated?
          _validation_errors.empty?
        end

        def _validation_errors
          @_validation_errors ||= Hash.new do |hash,key|
            hash[key] = []
          end
        end

        def _validated!
          @_validated = true
        end

        private

        def _validated?
          @_validated ||= false
        end
      end

    end
  end
end
