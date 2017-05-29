# frozen_string_literal: true

require 'set'
module Wardrobe
  module Plugins
    module Coercible
      module Refinements
        refine Set.singleton_class do
          def coerce(v, _atr)
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
            def _wardrobe_init(atr, coercer: nil)
              @_wardrobe_atr = atr
              @_wardrobe_coercer = coercer
              self
            end

            def _coerce(item)
              @_wardrobe_coercer.coerce(item, @_wardrobe_atr)
            end

            def add(item)
              super(_coerce(item))
            end

            def <<(item)
              super(_coerce(item))
            end

            # def <<(item)
            #   super(_coerce(item))
            # end
            #
            # def push(*items)
            #   super(*items.map { |i| _coerce(i) })
            # end
            #
            # def unshift(*items)
            #   super(*items.map { |i| _coerce(i) })
            # end
            #
            # def insert(index, item)
            #   super(index, _coerce(item))
            # end
          end

          def coerce(v, atr)
            res = case v
                  when NilClass then self.class.new
                  when Array, Set
                    v.to_set.map! { |i| first.coerce(i, nil) }
                  else
                    raise UnsupportedError
                  end

            res.singleton_class.include(SetInstanceCoercer)
            res._wardrobe_init(atr, coercer: first)
          end
        end
      end
    end
  end
end
