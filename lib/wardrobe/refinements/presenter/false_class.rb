# frozen_string_literal: true

module Wardrobe
  module Refinements
    module Presenter
      refine FalseClass do
        def _present(**options)
          self
        end
      end
    end
  end
end
