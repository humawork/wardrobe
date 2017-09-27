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
          base.wardrobe_config do
            add_store(:configurable_store, ConfigurableStore)
          end
          base.class_methods_module do
            define_method(:configurable_store) do
              @wardrobe_config.configurable_store
            end
          end
        end

        def configurable(name, setter_name, klass, before_update: nil, after_update: nil)
          validate_klass(klass)
          _create_configurable_set_method(
            name, setter_name, before_update: before_update, after_update: after_update
          )
          _create_configurable_get_method(name)
          wardrobe_config do
            @configurable_store = configurable_store.register(name, klass)
          end
        end

        def validate_klass(klass)
          unless klass.ancestors.include?(Wardrobe)
            raise InvalidConfigClass, "Configurable class #{klass} has not included Wardrobe"
          end
          unless klass.plugin_store.store[:immutable]
            raise InvalidConfigClass, "Configurable class #{klass} is missing the `:immutable` plugin"
          end
        end

        def _create_configurable_get_method(name)
          class_methods_module do
            define_method(name) do
              wardrobe_config.configurable_store[name]
            end
          end
        end

        def _create_configurable_set_method(name, setter_name, **opts)
          class_methods_module do
            define_method(setter_name) do |*args, **kargs, &blk|
              klass = self
              opts[:before_update].call(klass) if opts[:before_update]
              wardrobe_config do
                if args.any? || kargs.any?
                  @configurable_store = configurable_store.update(name, klass) do |object|
                    begin
                      object.configurable_update(*args, **kargs, &blk)
                    rescue NoMethodError => e
                      if e.message.match(/confgiurable_update/)
                        Wardrobe.logger.error("#{object.class} is missing a `#configurable_update` method")
                      end
                      raise e
                    end
                  end
                else
                  @configurable_store = configurable_store.update(name, klass, &blk)
                end
                if @configurable_store[name].class.plugin_store[:validation]
                  configurable_store[name]._validate!
                end
              end
              opts[:after_update].call(klass) if opts[:after_update]
            end
          end
        end
      end
    end
  end
  register_plugin(:configurable, Plugins::Configurable)
end
