# frozen_string_literal: true

module Wardrobe
  module Plugins
    module Presenter
      module Refinements
        refine Array do
          def _present(*args)
            map(&:_present)
          end
        end
      end
    end
  end
end
