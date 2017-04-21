module Atrs
  module Plugins
    module Configurable
      extend Atrs::Plugin

      class Runner
        def initialize(klass, blk)
          @klass = klass
          @blk = blk
        end

        def call
          self.instance_exec(self, &@blk)
        end

        def method_missing(name, other)
          binding.pry
        end
      end

      class ConfigurableStore < Store
        def register(name, klass)
          mutate do
            store.merge!(name => klass.new.freeze)
          end
        end

        def update(name, &blk)
          if frozen?
            dup.update(name, &blk)
          else
            duplicate = @store[name].dup
            blk.call(duplicate)
            @store = @store.merge(name => duplicate.freeze)
            freeze
          end
        end
      end

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
