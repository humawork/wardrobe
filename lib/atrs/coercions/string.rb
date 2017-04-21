module Atrs
  module Coercions

    # def self.extended(base)
    #   base.include(Coerce)
    #   base.instance_variable_set(:@coercers, {})
    # end
    #
    # def coercer(klass, &blk)
    #   coercers[klass] = blk
    # end
    #
    # def coercers
    #   self.instance_variable_get(:@coercers)
    # end
    #
    # module Coerce
    #
    #   def coerce(v, atr)
    #     binding.pry
    #   end
    #
    # end

    refine String.singleton_class do
      def coerce(v, atr)
        case v
        when self           then v
        when Integer, Float, Symbol then v.to_s
        when NilClass       then nil
        else
          raise UnsupportedError
        end
      end
    end
  end
end
