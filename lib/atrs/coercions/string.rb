module Atrs
  module Coercions
    refine String.singleton_class do
      def coerce(v, atr)
        case v
        when self           then v
        when Integer, Float then v.to_s
        when NilClass       then nil
        else
          raise UnsupportedError
        end
      end
    end
  end
end
