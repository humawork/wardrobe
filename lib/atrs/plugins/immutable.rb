# frozen_string_literal: true

module Atrs
  module Plugins
    module ImmutableInstanceMethods
      refine Object do
        def _mutating?
          instance_variable_defined?(:@_mutating) && @_mutating
        end

        def mutate(**args, &blk)
          dup.instance_exec do
            instance_variable_set(:@_mutating, true)
            blk.call(self) if block_given?
            args.each do |name, value|
              if atr = _attribute_store[name]
                _attribute_init(atr, args, name)
              end
            end
            remove_instance_variable(:@_mutating)
            deep_freeze
          end
        end

        def mutate!
          dup.instance_exec do
            instance_variable_set(:@_mutating, true)
            self
          end
        end
      end

      refine Hash do
        def deep_freeze
          each { |_k, v| v.deep_freeze }
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
          remove_instance_variable(:@_mutating) if instance_variable_defined?(:@_mutating)
          freeze
        end

        def mutate!
          dup.instance_exec do
            instance_variable_set(:@_mutating, true)
            map!(&:mutate!)
            self
          end
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
          remove_instance_variable(:@_mutating) if instance_variable_defined?(:@_mutating)
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
        use_if: ->(_atr) { true },
        setter: lambda do |value, atr, instance|
          if instance._initializing? || !instance.frozen?
            value
          else
            raise NoMethodError, <<~eos
              undefined method `#{atr.name}=' for #{instance}.
              The instance is immutable. Use `#mutate(key, value)' or `#mutate { |obj| obj.#{atr.name} = #{value.inspect}}'
            eos
          end
        end
      )

      Atrs.register_getter(
        name: :dup_when_using_set_block,
        priority: 100,
        use_if: ->(atr) { true },
        getter: lambda do |value, atr, instance|
          using ImmutableInstanceMethods
          if instance._initializing?
            value
          elsif instance._mutating?
            instance.instance_variable_set(atr.ivar_name, value.mutate!)
          else
            value
          end
        end
      )

      option :immutable, Boolean, default: true,
             setter: :disable_setter_for_immutable_plugin,
             getter: :dup_when_using_set_block

      module InstanceMethods
        using ImmutableInstanceMethods
        def initialize(**hash)
          super
          freeze
        end

        def mutate(**args, &blk)
          super
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
