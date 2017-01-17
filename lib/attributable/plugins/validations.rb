require_relative 'validations/refinements/integer'
require_relative 'validations/refinements/string'
require_relative 'validations/refinements/nil_class'
require_relative 'validations/validator'

module Attributable
  module Plugins
    module Validations
      extend Attributable::Plugin
      option :validates, Hash

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
