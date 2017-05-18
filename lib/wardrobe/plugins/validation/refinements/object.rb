# frozen_string_literal: true

module Wardrobe
  module Plugins
    module Validation
      module Refinements
        refine Object do
          def _inspect
            inspect
          end

          def included_in?(list)
            return if list.include?(self)
            "must be one of: #{list.map(&:_inspect).join(', ')}"
          end

          def excluded_from?(list)
            return unless list.include?(self)
            "must not be one of: #{list.map(&:_inspect).join(', ')}"
          end

          def type?(predicate)
            return if self.is_a?(predicate)
            if predicate == Wardrobe::Boolean
              return if self.is_a?(TrueClass) || self.is_a?(FalseClass)
              "must be a TrueClass or FalseClass"
            else
              "must be a #{predicate}"
            end
          end
        end
      end
    end
  end
end
