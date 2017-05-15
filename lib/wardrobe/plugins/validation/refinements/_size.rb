# frozen_string_literal: true

module Wardrobe
  module Plugins
    module Validation
      module Refinements
        module Size
          def size?(predicate_value)
            return if predicate_value === size
            if predicate_value.is_a?(Range)
              "size must be within #{predicate_value.min} - #{predicate_value.max}"
            else
              "size must be #{predicate_value}"
            end
          end

          def min_size?(predicate_value)
            return if predicate_value <= size
            "size cannot be less than #{predicate_value}"
          end

          def max_size?(predicate_value)
            return if predicate_value >= size
            "size cannot be greater than #{predicate_value}"
          end
        end
      end
    end
  end
end
