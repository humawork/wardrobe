module Attributable
  module Coercions
    refine Integer.singleton_class do
      def coerce(v)
        case v
        when self then v
        when String, Float
          v.to_i
        end
      end
    end
  end
end
