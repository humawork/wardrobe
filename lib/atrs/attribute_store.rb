module Atrs
  class AttributeStore < Store
    def add(name, klass, defining_object, config, **args, &blk)
      mutate {
        attribute = Attribute.new(name, klass, defining_object, config, self, **args, &blk)
        if store[name]
          store[name] = store[name].merge(attribute, defining_object, config, self)
        else
          store[name] = attribute
        end
      }
    end
  end
end
