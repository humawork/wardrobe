# frozen_string_literal: true

require_relative 'validation/refinements'
require_relative 'validation/deep_merge'
require_relative 'validation/error_store'
require_relative 'validation/instance_methods'
require_relative 'validation/validation'
require_relative 'validation/validator'
require_relative 'validation/validaton_runner'
require_relative 'validation/validation_error'
require_relative 'validation/class_methods'
require_relative 'validation/block_handler'
require_relative 'validation/setter'

# TODO:
# - Setting to run validations automatically
# - Support all Hanami/Dry validations
# - Support advanced predicates

module Wardrobe
  module Plugins
    module Validation
      extend Wardrobe::Plugin
      option :validates, Hash
      option :required, Boolean, default: true
      module ClassMethods
        def self.extended(base)
          if base.plugin_store.store.dig(:validation, :options, :validate_on_set)
            base.add_default_setter(:validate)
          end
          if base.plugin_store.store.dig(:validation, :options, :validate_on_init)
            base.include(Initializer)
          end
        end
      end

      module Initializer
        def initialize(**args)
          super
          _validate!
        end
      end
    end
  end
  register_plugin(:validation, Plugins::Validation)
end
