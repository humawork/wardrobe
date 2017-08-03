# frozen_string_literal: true

module Wardrobe
  module Plugins
    module Coercible
      module Refinements
        refine Hash.singleton_class do
          def coerce(v, _atr)
            case v
            when self then v
            when Array then self[*v]
            when NilClass then {}
            end
          end
        end

        refine Hash do
          def coerce(v, atr)
            case v
            when Hash
              coerce_hash(v, atr)
            when Array
              coerce_hash(self.class[*v], atr)
            when NilClass
              coerce_hash({}, atr)
            else
              raise UnsupportedError
            end
          end

          module HashInstanceCoercer

            def _wardrobe_init(atr, coercer: nil)
              @_wardrobe_atr = atr
              @_wardrobe_coercer = coercer
              self
            end

            def _coerce(key, value)
              return @_wardrobe_coercer[0].coerce(key, nil),
                     @_wardrobe_coercer[1].coerce(value, nil)
            end

            def dup
              duplicate = super
              duplicate.singleton_class.include(HashInstanceCoercer)
              duplicate
            end

            def []=(key, value)
              super(*_coerce(key, value))
            end

            def merge!(other)
              other.each do |key, value|
                self[key] = value
              end
            end

            def store(key, value)
              self[key] = value
            end
          end

          private

          def coerce_hash(h, atr)
            hash = h.map do |key, value|
              [first[0].coerce(key, nil), first[1].coerce(value, nil)]
            end.to_h

            hash.singleton_class.include(HashInstanceCoercer)
            hash._wardrobe_init(atr, coercer: first)
            hash
          end
        end
      end
    end
  end
end
