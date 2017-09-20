# frozen_string_literal: true

module Wardrobe
  module Refinements
    module Presenter
      refine Object do
        def _present(*_args)
          self
        end
      end
    end
  end
end
