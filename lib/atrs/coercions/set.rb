module Atrs
  module Coercions
    refine Set.singleton_class do
      def coerce(v, atr)
        case v
        when self then v
        when Array then v.to_set
        when NilClass then nil
        else
          raise UnsupportedError
        end
      end
    end
    refine Set do
      def coerce(v, atr)
        case v
        when NilClass then self.class.new
        when Array, Set
          v.to_set.map! { |i| first.coerce(i, nil) }
        else
          # binding.pry
        end
      end
    end
  end
end
