# frozen_string_literal: true
require 'set'

module Wardrobe
  module Plugins
    module ImmutableInstanceMethods
      IMMUTABLE_CORE_CLASSES = Set.new(
        [NilClass, TrueClass, FalseClass, Integer, Float, Symbol, Proc]
      )

      refine Object do
        def _mutating?
          instance_variable_defined?(:@_mutating) && @_mutating
        end

        def mutate(_options: {}, **args, &blk)
          dup.instance_exec do
            instance_variable_set(:@_mutating, true)
            instance_variable_set(:@_mutation_options, _options)
            blk.call(self) if block_given?
            args.each do |name, _value|
              if (atr = _attribute_store[name])
                _attribute_init(atr, args, name)
              end
            end
            remove_instance_variable(:@_mutating)
            remove_instance_variable(:@_mutation_options)
            deep_freeze
            self
          end
        end

        def deep_freeze
          freeze unless self.is_a?(Class)
        end

        def mutate!
          return self if IMMUTABLE_CORE_CLASSES.include?(self.class)
          dup.instance_exec do
            instance_variable_set(:@_mutating, true)
            self
          end
        end
      end
      refine OpenStruct do
        def deep_freeze
          self.each_pair do |k,v|
            v.deep_freeze
          end
          freeze
        end
        def mutate!
          dup.instance_exec do
            instance_variable_set(:@_mutating, true)
            self.each_pair do |k,v|
              self.send("#{k}=", v.mutate!)
            end
            self
          end
        end
      end

      refine Hash do
        def deep_freeze
          each { |k, v| k.deep_freeze; v.deep_freeze }
          freeze
        end

        def mutate!
          dup.instance_exec do
            instance_variable_set(:@_mutating, true)
            keys.each do |k|
              self[k.mutate!] = self.delete(k).mutate!
            end
            self
          end
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
      refine Wardrobe::InstanceMethods do
        def mutate!
          dup.instance_exec do
            instance_variable_set(:@_mutating, true)
            self
          end
        end

        def deep_freeze
          _attribute_store.each do |_name, atr|
            instance_variable_get(atr.ivar_name).deep_freeze if atr.options[:immutable]
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
        before: [:setter],
        use_if: ->(atr) { atr.options[:immutable] },
        setter: lambda do |value, atr, instance, _options|
          return value if instance._initializing? || !instance.frozen?
          raise NoMethodError, <<~eos
            undefined method `#{atr.name}=' for #{instance}.
            The instance is immutable. Use `#mutate(key, value)' or `#mutate { |obj| obj.#{atr.name} = #{value.inspect}}'
          eos
        end
      )

      Wardrobe.register_getter(
        name: :dup_when_using_set_block,
        after: [:getter],
        use_if: ->(atr) { atr.options[:immutable] },
        getter: lambda do |value, atr, instance, options|
          using ImmutableInstanceMethods
          if instance._initializing?
            value
          elsif instance._mutating?
            instance._set_attribute_value(atr, value.mutate!)
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
          deep_freeze
        end

        def mutate(**args, &blk)
          super
        end

        def _attribute_init(atr, hash, name)
          super
          send(atr.name)
        end
      end
    end
  end
  register_plugin(:immutable, Plugins::Immutable)
end
