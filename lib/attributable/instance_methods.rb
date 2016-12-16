module Attributable
  module InstanceMethods
    def initialize(*args, **kargs)
      @_attribute_set_singleton = nil
      kargs = args.merge(kargs) if args.any?
      _attributable_init(kargs.dup)
    end

    def _attribute_set
      @_attribute_set_singleton || self.class.attribute_set
    end

    def _add_attribute(name, klass, **args, &blk)
      @_attribute_set_singleton = _attribute_set.add(name, klass, **args, &blk)
    end

    private

    def _attributable_init(hash)
      _attribute_set.each do |name, atr|
        _attribute_init(atr, hash.delete(name) )
      end
    end

    def _attribute_init(atr, value)
      send(atr.setter_name, atr.coerce(value))
    end
  end
end
