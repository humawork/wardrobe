# frozen_string_literal: true

module Wardrobe
  module Plugins
    module Validation
      module Refinements
        refine ::TrueClass do
          def type?(predicate)
            return if predicate == Wardrobe::Boolean
            "must be a #{predicate.to_s}"
          end
        end
        refine ::FalseClass do
          def type?(predicate)
            return if predicate == Wardrobe::Boolean
            "must be a #{predicate.to_s}"
          end
        end
      end
    end
  end
end
