module Atrs
  module Coercions
    refine Time.singleton_class do
      def coerce(v, atr)
        case v
        when self     then v
        when Integer  then Time.at(v)
        when String   then Time.parse(v)
        when NilClass then nil
        else
          raise UnsupportedError
        end
      end
    end
  end
end
