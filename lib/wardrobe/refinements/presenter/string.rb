# frozen_string_literal: true

module Wardrobe
  module Refinements
    module Presenter
      refine String do
        def _present(**options)
          self
        end
      end
    end
  end
end
