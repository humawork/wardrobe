# frozen_string_literal: true
require 'set'

module Wardrobe
  module Plugins
    module ImmutableInstanceMethods
      IMMUTABLE_CORE_CLASSES = Set.new(
        [NilClass, TrueClass, FalseClass, Integer, Symbol]
      )

      refine Object do
        def _mutating?
          instance_variable_defined?(:@_mutating) && @_mutating
        end

        def mutate(**args, &blk)
          dup.instance_exec do
            instance_variable_set(:@_mutating, true)
            blk.call(self) if block_given?
            args.each do |name, _value|
              if atr = _attribute_store[name]
                _attribute_init(atr, args, name)
              end
            end
            remove_instance_variable(:@_mutating)
            deep_freeze
            self
          end
        end

        def mutate!
          return self if IMMUTABLE_CORE_CLASSES.include?(self.class)
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
      refine Set do
        def deep_freeze
          # Refinements does not work here when using &:deep_freeze like in array
          each { |item| item.deep_freeze }
          remove_instance_variable(:@_mutating) if instance_variable_defined?(:@_mutating)
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
      IMMUTABLE_CORE_CLASSES.each do |klass|
        refine klass do
          def deep_freeze
            freeze
          end
        end
      end
      refine Wardrobe::InstanceMethods do
        def mutate!
          dup.instance_exec do
            instance_variable_set(:@_mutating, true)
            self
          end
        end

        def deep_freeze
          if instance_variable_defined?(:@_data)
            @_data.deep_freeze
          else
            _attribute_store.each do |name,atr|
              instance_variable_get(atr.ivar_name).deep_freeze
            end
          end
          remove_instance_variable(:@_mutating) if instance_variable_defined?(:@_mutating)
          freeze
        end
      end
    end

    module Immutable
      extend Wardrobe::Plugin

      # This plugin will disable all setters. A "set(key, value)" will be enabled. Should we also use hash storage?
      # This should also depend on the optonal_setter plugin and set it to default on

      Wardrobe.register_setter(
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

      Wardrobe.register_getter(
        name: :dup_when_using_set_block,
        priority: 100,
        use_if: ->(_atr) { true },
        getter: lambda do |value, atr, instance|
          using ImmutableInstanceMethods
          if instance._initializing?
            value
          elsif instance._mutating?
            instance._set_attribute_value(atr, value.mutate!)
            # instance.instance_variable_set(atr.ivar_name, value.mutate!)
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
          _data.deep_freeze if instance_variable_defined?(:@_data)
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
