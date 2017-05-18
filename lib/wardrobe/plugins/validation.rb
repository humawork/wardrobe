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
    end
  end
  register_plugin(:validation, Plugins::Validation)
end
