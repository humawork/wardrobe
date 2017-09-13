# frozen_string_literal: true

module Wardrobe
  module Refinements
    module Coercible
      refine String.singleton_class do
        def coerce(v, _atr, _parent)
          case v
          when self then v
          when Integer, Float, Symbol then v.to_s
          when NilClass then nil
          else
            raise UnsupportedError
          end
        end
      end
    end
  end
end
