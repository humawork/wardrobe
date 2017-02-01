module Atrs
  module ModuleMethods
    # Method called when extended into module from Atrs.extended
    # def self.extended(base)
    #   base.instance_variable_set(:@attribute_set, AttributeSet.new)
    # end

    # Method called when module extended into is extended into another module/class
    def extended(base)
      base.extend(Atrs) unless base.respond_to?(:attribute_set)
      base.merge(self)
    end

    def merge(mod)
      @plugin_set = plugin_set.merge(mod.plugin_set)
      @option_set = option_set.merge(mod.option_set)
      @attribute_set = attribute_set.merge(mod.attribute_set)
    end

    def attribute(name, klass, **args, &blk)
      @attribute_set = attribute_set.add(name, klass, self, **args, &blk)
    end

    def attribute_set
      @attribute_set
    end
  end
end
