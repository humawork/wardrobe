module Attributable
  module Coercions
    refine Array.singleton_class do
      def coerce(v)
        case v
        when self then v
        else
          raise UnsupportedError
        end
      end
    end
    refine Array do
      def coerce(v)
        case v
        when Array
          v.map { |item| self.first.coerce(item) }
        when NilClass then nil
        else
          raise UnsupportedError
        end
      end
    end
  end
end
