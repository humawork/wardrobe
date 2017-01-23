module Attributable
  module Coercions
    refine Symbol.singleton_class do
      def coerce(v, atr)
        case v
        when self     then v
        when String   then v.to_sym
        when NilClass then nil
        else
          raise UnsupportedError
        end
      end
    end
  end
end
