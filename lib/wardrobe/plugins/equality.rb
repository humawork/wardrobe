module Wardrobe
  module Plugins
    module Equality
      extend Wardrobe::Plugin

      option :include_in_equality, Boolean, default: true

      module InstanceMethods
        def ==(other)
          return false unless other.class == self.class
          _attribute_store.all? do |_name, atr|
            return true unless atr.options[:include_in_equality]
            send(atr.name) == other.send(atr.name)
          end
        end
      end
    end
  end
  register_plugin(:equality, Plugins::Equality)
end
