module Attributable
  module Coercions
    refine Integer.singleton_class do
      def coerce(v, atr)
        case v
        when self          then v
        when String, Float then v.to_i
        when NilClass      then nil
        else
          raise UnsupportedError
        end
      end
    end
  end
end
