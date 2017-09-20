# frozen_string_literal: true

module Wardrobe
  module Refinements
    module Path
      refine Object do
        def at(*args)
          self
        end
      end
    end
  end
end
