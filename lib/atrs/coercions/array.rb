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

    refine Array do
      class WrongNumberOfItemsError < StandardError; end
      def coerce(v, atr)
        case v
        when Array

          # This check shold be moved to attribute creation time
          raise StandardError, "`Array#{map(&:name)}' contains two many classes. No more than one is allowed." if count != 1
          v.map! { |item| first.coerce(item, nil) }
          # This is a major hack but it works. Should we create anonymous classes at attribute init for Array, Hash and Set? Or do another go on Atrs::Classes::Array
          v.singleton_class.class_exec(first, atr) do |klass, atr_object|
            @_coercer = klass
            @_atr = atr_object

            def self._coercer; @_coercer; end
            def self._atr; @_atr; end

            def _coerce(item)
              self.singleton_class._coercer.coerce(item, self.singleton_class._atr)
            end

            def <<(item)
              super _coerce(item)
            end

            def push(*items)
              super(*items.map { |i| _coerce(i) })
            end

            def unshift(*items)
              super(*items.map { |i| _coerce(i) })
            end
          end
          v
        when NilClass then self.class.new
        else
          raise UnsupportedError
        end
      end
    end
  end
end
