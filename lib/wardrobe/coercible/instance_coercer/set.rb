module Wardrobe
  module Coercible
    module InstanceCoercer
      module Set
        def self.init(val, klass, parent, atr)
          val = val.to_set.map! do |item|
            Wardrobe::Coercible.coerce(item, to: klass.first, parent: parent, atr: atr)
          end
          val.singleton_class.include(self)
          val._wardrobe_init(klass, parent: parent, atr: atr)
          val
        end

        def _wardrobe_init(klass, parent: nil, atr: nil)
          @_wardrobe_coercer = klass.first
          @_wardrobe_atr = atr
          @_wardrobe_parent = parent
          self
        end

        def _coerce(item)
          Wardrobe::Coercible.coerce(item, to: @_wardrobe_coercer, parent: @_wardrobe_parent, atr: @_wardrobe_atr)
        end

        def dup
          duplicate = super
          duplicate.singleton_class.include(InstanceCoercer::Set)
          duplicate
        end

        def add(item)
          super(_coerce(item))
        end

        def <<(item)
          super(_coerce(item))
        end
      end
    end
  end
end
