# frozen_string_literal: true

module Wardrobe
  module Refinements
    module Coercible
      refine BasicObject.singleton_class do
        def coerce(v, _atr, _parent)
          v
        end
      end
    end
  end
end
