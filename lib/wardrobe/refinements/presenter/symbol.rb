# frozen_string_literal: true

module Wardrobe
  module Refinements
    module Presenter
      refine Symbol do
        def _present(**options)
          self
        end
      end
    end
  end
end
