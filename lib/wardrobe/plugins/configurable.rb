# frozen_string_literal: true

require_relative 'configurable/configurable_store'

module Wardrobe
  module Plugins
    module Configurable
      extend Wardrobe::Plugin

      module ClassMethods
        extend Forwardable

        def self.extended(base)
          super
          base.wardrobe_stores do
            add_store(:configurable_store, ConfigurableStore)
          end
          base.instance_variable_get(:@wardrobe_class_methods).class_exec do
            def configurable_store
              @wardrobe_stores.configurable_store
            end
          end
        end

        def configurable(name, blk_name, klass, before_update: nil, after_update: nil)
          wardrobe_stores do
            @configurable_store = configurable_store.register(name, klass)
          end
          _create_configurable_methods(
            name, blk_name, before_update: before_update, after_update: after_update
          )
        end

        def _create_configurable_methods(name, blk_name, **args)
          @wardrobe_class_methods.class_exec do
            define_method(name) do
              wardrobe_stores.configurable_store[name]
            end
            define_method(blk_name) do |&blk|
              klass = self
              wardrobe_stores do
                args[:before_update].call(klass) if args[:before_update]
                @configurable_store = configurable_store.update(name, &blk)
                args[:after_update].call(klass) if args[:after_update]
              end
            end
          end
        end
      end
    end
  end
  register_plugin(:configurable, Plugins::Configurable)
end
