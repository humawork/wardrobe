# frozen_string_literal: true

module Wardrobe
  module Plugins
    module Coercible
      module Refinements
        refine Hash.singleton_class do
          def coerce(v, _atr, _parent)
            case v
            when self then v
            when Array then self[*v]
            when NilClass then {}
            end
          end
        end

        refine Hash do
          def coerce(v, atr, parent)
            case v
            when Hash
              coerce_hash(v, atr, parent)
            when Array
              coerce_hash(self.class[*v], atr, parent)
            when NilClass
              coerce_hash({}, atr, parent)
            else
              raise UnsupportedError
            end
          end

          module HashInstanceCoercer

            def _wardrobe_init(atr, coercer: nil, parent: nil)
              @_wardrobe_atr = atr
              @_wardrobe_coercer = coercer
              @_wardrobe_parent = parent
              self
            end

            def _coerce(key, value)
              return @_wardrobe_coercer[0].coerce(key, nil, @_wardrobe_parent),
                     @_wardrobe_coercer[1].coerce(value, nil, @_wardrobe_parent)
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

          def coerce_hash(h, atr, parent)
            hash = h.map do |key, value|
              [first[0].coerce(key, nil, parent), first[1].coerce(value, nil, parent)]
            end.to_h

            hash.singleton_class.include(HashInstanceCoercer)
            hash._wardrobe_init(atr, coercer: first, parent: parent)
            hash
          end
        end
      end
    end
  end
end
