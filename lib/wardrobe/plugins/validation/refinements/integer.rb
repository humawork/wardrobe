# frozen_string_literal: true

module Wardrobe
  module Plugins
    module Validation
      module Refinements
        refine Integer do
          def odd?
            return if super
            'must be odd'
          end

          def even?
            return if super
            'must be even'
          end
        end
      end
    end
  end
end
