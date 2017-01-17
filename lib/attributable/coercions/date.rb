module Attributable
  module Coercions
    refine Date.singleton_class do
      def coerce(v)
        case v
        when self then v
        when Integer
          Time.at(v)
        when String
          Time.parse(v)
        when NilClass
          nil
        else
          raise UnsupportedError
        end
      end
    end
  end
end
