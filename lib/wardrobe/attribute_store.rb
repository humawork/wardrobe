# frozen_string_literal: true

module Wardrobe
  class AttributeStore < Store
    def add(name, klass, defining_object, config, **args, &blk)
      mutate do
        attribute = Attribute.new(name, klass, defining_object, config, **args)
        blk.call(attribute) if block_given?
        if store[name]
          store[name] = store[name].merge(attribute, defining_object, config)
        else
          store[name] = attribute
        end
      end
    end
  end
end
