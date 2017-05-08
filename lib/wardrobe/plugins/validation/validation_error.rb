# frozen_string_literal: true

module Wardrobe
  module Plugins
    module Validation
      class ValidationError < StandardError
        attr_reader :errors

        def initialize(errors)
          @errors = errors.freeze
        end

        def to_s
          errors
        end
      end
    end
  end
end
