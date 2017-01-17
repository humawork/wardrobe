module Attributable
  module Coercions
    refine String.singleton_class do
      def coerce(v)
        case v
        when self then v
        when Integer, Float
          v.to_s
        when NilClass
          nil
        else
          raise UnsupportedError
        end
      end
    end
  end
end
