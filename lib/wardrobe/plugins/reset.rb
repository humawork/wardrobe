module Wardrobe
  module Plugins
    module Reset
      extend Wardrobe::Plugin

      module InstanceMethods
        def _reset
          initialize
        end

        def _reset!
          self.class.new
        end
      end
    end
  end
  register_plugin(:reset, Plugins::Reset)
end
