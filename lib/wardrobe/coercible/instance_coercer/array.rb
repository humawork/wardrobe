module Wardrobe
  module Coercible
    module InstanceCoercer
      module Array
        def self.init(val, klass, parent, atr)
          val = val.to_a.map! do |item|
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
          duplicate.singleton_class.include(InstanceCoercer::Array)
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
    end
  end
end
