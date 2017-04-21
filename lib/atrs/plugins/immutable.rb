module Atrs
  module Plugins
    module DeepFreeze
      refine Hash do
        def deep_freeze
          each { |k,v| v.deep_freeze }
          freeze
        end
      end
      refine String do
        def deep_freeze
          freeze
        end
      end
      refine Array do
        def deep_freeze
          each(&:deep_freeze)
          freeze
        end
      end
      [Integer, Symbol, NilClass].each do |klass|
        refine klass do
          def deep_freeze; end
        end
      end
      refine Atrs::InstanceMethods do
        def deep_freeze
          _attribute_store.each do |name,atr|
            instance_variable_get(atr.ivar_name).deep_freeze
          end
          freeze
        end
      end
    end
    module Immutable
      extend Atrs::Plugin

      # This plugin will disable all setters. A "set(key, value)" will be enabled. Should we also use hash storage?
      # This should also depend on the optonal_setter plugin and set it to default on

      Atrs.register_setter(
        name: :disable_setter_for_immutable_plugin,
        priority: -101,
        use_if: ->(atr) { true },
        setter: ->(value, atr, instance) {
          if instance._initializing? || !instance.frozen?
            value
          else
            raise NoMethodError.new(
              <<~eos
                undefined method `#{atr.name}=' for #{instance}.
                The instance is immutable. Use `#mutate(key, value)' or `#mutate { |obj| obj.#{atr.name} = #{value.inspect}}'
              eos
            )
          end
        }
      )

      Atrs.register_getter(
        name: :dup_when_using_set_block,
        priority: 100,
        use_if: ->(atr) { true },
        getter: ->(value, atr, instance) {
          if instance._initializing?
            value
          elsif !instance.frozen?
            instance.instance_variable_set(atr.ivar_name, value.dup)
          else
            value
          end
        }
      )

      option :immutable, Boolean, default: true, setter: :disable_setter_for_immutable_plugin, getter: :dup_when_using_set_block

      module InstanceMethods
        using DeepFreeze
        def initialize(**hash)
          super
          freeze
        end

        def mutate(**args, &blk)
          dup.instance_exec do
            if block_given?
              blk.call(self)
            end
            if args.any?
              _initialize {
                _atrs_init(args)
              }
            end
            deep_freeze
          end
        end

        def _attribute_init(atr, hash, name)
          super
          send(atr.name).deep_freeze
        end
      end
    end
  end
  register_plugin(:immutable, Plugins::Immutable)
end
