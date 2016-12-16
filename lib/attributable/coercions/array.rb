module Attributable
  module Coercions
    refine Array.singleton_class do
      def coerce(v)
        case v
        when self then v
        end
      end
    end
  end
end
