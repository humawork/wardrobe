# frozen_string_literal: true

module Atrs
  module Coercions
    refine Array.singleton_class do
      def coerce(v, atr)
        case v
        when self     then v
        when Set      then v.to_a
        when NilClass then []
        else
          raise UnsupportedError
        end
      end
    end

    module ArrayInstanceCoercer
      def _atrs_init(atr, coercer: nil)
        @_atrs_atr = atr
        @_atrs_coercer = coercer
        self
      end

      def _coerce(item)
        @_atrs_coercer.coerce(item, @_atrs_atr)
      end

      def <<(item)
        super(_coerce(item))
      end

      def push(*items)
        super(*items.map { |i| _coerce(i) })
      end

      def unshift(*items)
        super(*items.map { |i| _coerce(i) })
      end
    end

    refine Array do
      class WrongNumberOfItemsError < StandardError; end

      def coerce(v, atr)
        res = case v
              when Array
                v.map! { |item| first.coerce(item, nil) }
              when NilClass then []
              else
                raise UnsupportedError
              end
        res.singleton_class.include(ArrayInstanceCoercer)
        res._atrs_init(atr, coercer: first)
      end
    end
  end
end
