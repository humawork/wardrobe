# frozen_string_literal: true

module Atrs
  module Plugins
    module Coercible
      module Refinements
        refine Hash.singleton_class do
          def coerce(v, _atr)
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
              coerce_hash(v, atr)
            when Array
              coerce_hash(self.class[*v], atr)
            when NilClass then {}
            else
              raise UnsupportedError
            end
          end

          private

          def coerce_hash(h, atr)
            hash = h.map do |key, value|
              #TODO: Since we pass around the atr object, how should this work here? Just pass nil?
              [self.first[0].coerce(key, nil), self.first[1].coerce(value, nil)]
            end.to_h

            hash.singleton_class.class_exec(first, atr) do |coercer, atr_object|
              @_coercer = coercer
              @_atr = atr_object

              def _coercer
                self.singleton_class.instance_variable_get(:@_coercer)
              end

              def self._atr; @_atr; end

              def _coerce(key, value)
                return _coercer[0].coerce(key, nil),
                       _coercer[1].coerce(value, nil)
              end

              def []=(key, value)
                super(*_coerce(key,value))
              end

            end
            hash
          end
        end
      end
    end
  end
end
