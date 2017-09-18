module Wardrobe
  module Coercible
    module InstanceCoercer
      module Array
        def self.init(val, klass, parent)
          val = val.to_a.map! do |item|
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
