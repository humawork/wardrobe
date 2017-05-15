# frozen_string_literal: true

module Wardrobe
  module Plugins
    module Validation
      module Refinements
        refine ::Date do
          def _inspect
            to_s
          end
        end
      end
    end
  end
end
