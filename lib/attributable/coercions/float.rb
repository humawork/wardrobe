module Attributable
  module Coercions
    refine Float.singleton_class do
      def coerce(v)
        case v
        when self then v
        when String, Integer
          v.to_f
        end
      end
    end
  end
end
