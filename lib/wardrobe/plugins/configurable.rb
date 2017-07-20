# frozen_string_literal: true

require_relative 'configurable/configurable_store'

module Wardrobe
  module Plugins
    module Configurable
      extend Wardrobe::Plugin

      class InvalidConfigClass < StandardError; end

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
          unless klass.ancestors.include?(Wardrobe)
            raise InvalidConfigClass, "Configurable class #{klass} has not included Wardrobe"
          end
          unless klass.plugin_store.store[:immutable]
            raise InvalidConfigClass, "Configurable class #{klass} is missing the `:immutable` plugin"
          end
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
              args[:before_update].call(klass) if args[:before_update]
              wardrobe_stores do
                @configurable_store = configurable_store.update(name, klass, &blk)
                if @configurable_store[name].class.plugin_store[:validation]
                  configurable_store[name]._validate!
                end
              end
              args[:after_update].call(klass) if args[:after_update]
            end
          end
        end
      end
    end
  end
  register_plugin(:configurable, Plugins::Configurable)
end
