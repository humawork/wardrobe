require_relative 'configurable/configurable_store'

module Atrs
  module Plugins
    module Configurable
      extend Atrs::Plugin

      module ClassMethods
        def self.extended(base)
          super
          base.atrs_config do
            add_store(:configurable_store, ConfigurableStore)
          end
        end

        def configurable(name, blk_name, klass)
          atrs_config do
            @configurable_store = configurable_store.register(name, klass)
          end

          define_singleton_method(name) do
            atrs_config.configurable_store[name]
          end

          define_singleton_method(blk_name) do |&blk|
            atrs_config do
              @configurable_store = configurable_store.update(name, &blk)
            end
          end
        end
      end
    end
  end
  register_plugin(:configurable, Plugins::Configurable)
end
