module Atrs
  module Coercions
    refine Float.singleton_class do
      def coerce(v, atr)
        case v
        when self then v
        when String, Integer then v.to_f
        when NilClass then nil
        else
          raise UnsupportedError
        end
      end
    end
  end
end
