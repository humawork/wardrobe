# frozen_string_literal: true

module Atrs
  module Plugins
    module Validation
      module Refinements
        refine Integer do
          def gte(int)
            return unless self >= int
            "integer #{self} violates greater than or equal to #{int}"
          end

          def gt(int)
            return unless self > int
            "Error"
          end

          def eq(int)
            return unless self == int
            "#{self} violates equality with #{int}"
          end
        end
      end
    end
  end
end
