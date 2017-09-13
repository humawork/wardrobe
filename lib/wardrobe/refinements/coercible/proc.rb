# frozen_string_literal: true

module Wardrobe
  module Refinements
    module Coercible
      refine Proc.singleton_class do
        def coerce(v, _atr, _parent)
          case v
          when self then v
          when NilClass then nil
          else
            raise UnsupportedError
          end
        end
      end
      refine Proc do
        def coerce(v, atr, parent)
          call(v, atr, parent)
        end
      end
    end
  end
end
