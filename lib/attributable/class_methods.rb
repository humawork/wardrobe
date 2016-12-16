module Attributable
  module ClassMethods
    def self.extended(base)
      base.instance_variable_set(:@attribute_set, AttributeSet.new)
    end

    # This will be invoked when a module with extended Attributable is
    # extended into a class or another module
    def extended(base)
      base.extend(Attributable) unless base.respond_to?(:extend_attributes)
      base.extend_attributes(attribute_set)
    end

    def extend_attributes(attributes_to_extend)
      @attribute_set = attribute_set.merge(attributes_to_extend)
    end

    def inherited(base)
      base.instance_variable_set(:@attribute_set, attribute_set)
    end

    def attribute(name, klass, **args, &blk)
      @attribute_set = attribute_set.add(name, klass, **args, &blk)
      atr = @attribute_set[name]
      define_method(atr.getter_name) do
        instance_variable_get(atr.ivar_name)
      end
      define_method(atr.setter_name) do |val|
        instance_variable_set(atr.ivar_name, atr.set_with_plugins(val, self))
      end
    end

    def attributes(**kargs, &blk)
      BlockRunner.new(self).run(**kargs, &blk)
    end

    def remove_attributes(*atrs)
      atrs.each do |atr|
        @attribute_set = attribute_set.del(atr)
      end
    end

    alias remove_attribute remove_attributes

    def coerce(val)
      new(val)
    end

    def attribute_set
      @attribute_set
    end
  end
end
