module Attributable
  module Coercions
    refine Symbol.singleton_class do
      def coerce(v)
        case v
        when self then v
        when String
          v.to_sym
        when NilClass
          nil
        else
          raise UnsupportedError
        end
      end
    end
  end
end
