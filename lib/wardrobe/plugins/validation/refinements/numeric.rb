# frozen_string_literal: true

module Wardrobe
  module Plugins
    module Validation
      module Refinements
        refine Numeric do
          def gt?(num)
            return if self > num
            "must be greater than #{num}"
          end

          def lt?(num)
            return if self < num
            "must be less than #{num}"
          end

          def lteq?(num)
            return if self <= num
            "must be less than or equal to #{num}"
          end

          def gteq?(num)
            return if self >= num
            "must be greater than or equal to #{num}"
          end
        end
      end
    end
  end
end
