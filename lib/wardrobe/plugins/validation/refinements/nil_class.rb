# frozen_string_literal: true

module Wardrobe
  module Plugins
    module Validation
      module Refinements
        refine NilClass do
          def filled?
            'must be filled'
          end

          def empty?
            # Nil is valid as empty
          end
        end
      end
    end
  end
end
