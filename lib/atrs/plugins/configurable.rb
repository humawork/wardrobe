# frozen_string_literal: true

require_relative 'configurable/configurable_store'

module Atrs
  module Plugins
    module Configurable
      extend Atrs::Plugin

      module ClassMethods
        extend Forwardable
        def_delegators :@atrs_stores, :configurable_store
        
        def self.extended(base)
          super
          base.atrs_stores do
            add_store(:configurable_store, ConfigurableStore)
          end
        end

        def configurable(name, blk_name, klass)
          atrs_stores do
            @configurable_store = configurable_store.register(name, klass)
          end

          define_singleton_method(name) do
            atrs_stores.configurable_store[name]
          end

          define_singleton_method(blk_name) do |&blk|
            atrs_stores do
              @configurable_store = configurable_store.update(name, &blk)
            end
          end
        end
      end
    end
  end
  register_plugin(:configurable, Plugins::Configurable)
end
