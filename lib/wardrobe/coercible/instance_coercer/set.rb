module Wardrobe
  module Coercible
    module InstanceCoercer
      module Set
        def self.init(val, klass, parent)
          val = val.to_set.map! do |item|
            Wardrobe::Coercible.coerce(item, to: klass.first, parent: parent)
          end
          val.singleton_class.include(self)
          val._wardrobe_init(klass, parent: parent)
          val
        end

        def _wardrobe_init(klass, parent: nil)
          @_wardrobe_coercer = klass.first
          @_wardrobe_parent = parent
          self
        end

        def _coerce(item)
          Wardrobe::Coercible.coerce(item, to: @_wardrobe_coercer, parent: @_wardrobe_parent)
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
