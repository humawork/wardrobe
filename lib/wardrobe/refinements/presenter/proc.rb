# frozen_string_literal: true

module Wardrobe
  module Refinements
    module Presenter
      refine Proc do
        def _present(**options)
          call(**options)
        end
      end
    end
  end
end
