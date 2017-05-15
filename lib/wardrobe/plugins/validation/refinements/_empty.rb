# frozen_string_literal: true

module Wardrobe
  module Plugins
    module Validation
      module Refinements
        module Empty
          def empty?
            return if original_empty?
            'must be empty'
          end
        end
      end
    end
  end
end
