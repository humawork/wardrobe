# frozen_string_literal: true

module Wardrobe
  module Refinements
    module Path
      class PathError < StandardError; end

      refine Array do
        def at(item = nil, *remainder)
          unless item.match?(/^\d*$/)
            raise PathError, "path on array has to be a number `#{item}` given"
          end
          res = self[item.to_i]
          remainder.any? ? res&.at(*remainder) : res
        end
      end
    end
  end
end
