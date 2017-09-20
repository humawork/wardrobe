# frozen_string_literal: true

module Wardrobe
  module Refinements
    module Path
      refine Hash do
        def at(item = nil, *remainder)
          res = self[item.to_sym]
          remainder.any? ? res&.at(*remainder) : res
        end
      end
    end
  end
end
