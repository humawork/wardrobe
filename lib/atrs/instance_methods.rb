module Atrs
  module InstanceMethods
    def initialize(**hash)
      # raise "POC: More than one arg not supported..." if args.length > 1
      # kargs = args.first.merge(kargs) if args.any?
      @initialized = false
      _atrs_init(hash)
      @initialized = true
    end
    # def initialize(*args, **kargs)
    #   raise "POC: More than one arg not supported..." if args.length > 1
    #   kargs = args.first.merge(kargs) if args.any?
    #   _atrs_init(kargs.dup)
    # end

    def _attribute_set
      if instance_variable_defined?('@_attribute_set_singleton')
        @_attribute_set_singleton
      else
        self.class.attribute_set
      end
    end

    def _add_attribute(name, klass, **args, &blk)
      @_attribute_set_singleton = _attribute_set.add(name, klass, **args, &blk)
    end

    def initialized?
      @initialized
    end

    private

    def _atrs_init(hash)
      _attribute_set.each do |name, atr|
        _attribute_init(atr, hash, name)
      end
    end

    def _attribute_init(atr, hash, name)
      send(atr.setter_name, atr.coerce(hash[name]))
    end
  end
end
