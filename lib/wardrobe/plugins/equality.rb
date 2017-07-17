module Wardrobe
  module Plugins
    module Equality
      extend Wardrobe::Plugin

      option :exclude_from_equality, Boolean, default: false

      module InstanceMethods
        def ==(other)
          return false unless other.class == self.class
          _attribute_store.all? do |_name, atr|
            return true if atr.options[:exclude_from_equality]
            send(atr.name) == other.send(atr.name)
          end
        end
      end
    end
  end
  register_plugin(:equality, Plugins::Equality)
end
