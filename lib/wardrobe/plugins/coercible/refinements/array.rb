# frozen_string_literal: true

module Wardrobe
  module Plugins
    module Coercible
      module Refinements
        refine Array.singleton_class do
          def coerce(v, _atr)
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

          module ArrayInstanceCoercer
            def _wardrobe_init(atr, coercer: nil)
              @_wardrobe_atr = atr
              @_wardrobe_coercer = coercer
              self
            end

            def _coerce(item)
              @_wardrobe_coercer.coerce(item, @_wardrobe_atr)
            end

            def dup
              duplicate = super
              duplicate.singleton_class.include(ArrayInstanceCoercer)
              duplicate
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

            def insert(index, item)
              super(index, _coerce(item))
            end
          end

          def coerce(v, atr)
            res = case v
                  when Array
                    v.map! { |item| first.coerce(item, nil) }
                  when NilClass then []
                  else
                    raise UnsupportedError
                  end
            res.singleton_class.include(ArrayInstanceCoercer)
            res._wardrobe_init(atr, coercer: first)
          end
        end
      end
    end
  end
end
