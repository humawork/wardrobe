module Wardrobe
  module Coercible
    module InstanceCoercer
      module Hash
        def self.init(val, klass, parent)
          val = val.map do |key, value|
            [
              Wardrobe::Coercible.coerce(key, to: klass.first[0], parent: parent),
              Wardrobe::Coercible.coerce(value, to: klass.first[1], parent: parent)
            ]
          end.to_h
          val.singleton_class.include(self)
          val._wardrobe_init(klass, parent: parent)
          val
        end

        def _wardrobe_init(klass, parent: nil)
          @_wardrobe_coercer = klass.first
          @_wardrobe_parent = parent
          self
        end

        def _coerce(key, value)
          return Wardrobe::Coercible.coerce(key, to: @_wardrobe_coercer[0], parent: @_wardrobe_parent),
                 Wardrobe::Coercible.coerce(value, to: @_wardrobe_coercer[1], parent: @_wardrobe_parent)
        end

        def dup
          duplicate = super
          duplicate.singleton_class.include(InstanceCoercer::Hash)
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
    end
  end
end
