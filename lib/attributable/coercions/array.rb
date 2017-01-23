module Attributable
  module Coercions
    refine Array.singleton_class do
      def coerce(v, atr)
        case v
        when self     then v
        when NilClass then []
        else
          raise UnsupportedError
        end
      end
    end
    refine Array do
      def coerce(v, atr)
        case v
        when Array
          v.map { |item| self.first.coerce(item, nil) }
        when NilClass then []
        else
          raise UnsupportedError
        end
      end
    end
  end
end
