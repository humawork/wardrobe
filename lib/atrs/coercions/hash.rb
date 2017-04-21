module Atrs
  module Coercions
    refine Hash.singleton_class do
      def coerce(v, atr)
        case v
        when self then v
        when Array then self[*v]
        when NilClass then {}
        else
          raise UnsupportedError
        end
      end
    end
    refine Hash do
      def coerce(v, atr)
        case v
        when Hash
          coerce_hash(v)
        when Array
          coerce_hash(self.class[*v])
        when NilClass then {}
        else
          raise UnsupportedError
        end
      end

      private

      def coerce_hash(h)
        h.map do |key, value|
          #TODO: Since we pass around the atr object, how should this work here? Just pass nil?
          [self.first[0].coerce(key, nil), self.first[1].coerce(value, nil)]
        end.to_h
      end
    end
  end
end
