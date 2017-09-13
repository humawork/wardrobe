# frozen_string_literal: true

module Wardrobe
  module Refinements
    module Coercible
      refine Set.singleton_class do
        def coerce(v, _atr, _parent)
          case v
          when self then v
          when Array then v.to_set
          when NilClass then new
          else
            raise UnsupportedError
          end
        end
      end
      refine Set do

        module SetInstanceCoercer
          def _wardrobe_init(atr, coercer: nil, parent: nil)
            @_wardrobe_atr = atr
            @_wardrobe_coercer = coercer
            @_wardrobe_parent = parent
            self
          end

          def _coerce(item)
            @_wardrobe_coercer.coerce(item, @_wardrobe_atr, @_wardrobe_parent)
          end

          def dup
            duplicate = super
            duplicate.singleton_class.include(SetInstanceCoercer)
            duplicate
          end

          def add(item)
            super(_coerce(item))
          end

          def <<(item)
            super(_coerce(item))
          end
        end

        def coerce(v, atr, parent)
          res = case v
                when NilClass then self.class.new
                when Array, Set
                  v.to_set.map! { |i| first.coerce(i, nil, parent) }
                else
                  raise UnsupportedError
                end

          res.singleton_class.include(SetInstanceCoercer)
          res._wardrobe_init(atr, coercer: first, parent: parent)
        end
      end
    end
  end
end
