# frozen_string_literal: true

module Wardrobe
  module Plugins
    module Presenter
      module Refinements
        refine Hash do
          def _present(*args)
            transform_values(&:_present)
          end
        end
      end
    end
  end
end
