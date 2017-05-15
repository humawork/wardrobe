# frozen_string_literal: true

module Wardrobe
  module Plugins
    module Validation

      module DeepMerge
        refine Array do
          def deep_merge!(other)
            self.push(*other)
          end
        end
        refine Hash do
          def deep_merge!(other)
            other.each do |key, value|
              if has_key?(key)
                self[key].deep_merge!(value)
              else
                self[key] = value
              end
            end
          end
        end
      end

      class ErrorStore
        attr_reader :store

        using DeepMerge
        def initialize
          @store = Hash.new { |hash, key| hash[key] = Array.new }
        end

        def add(atr, *errors)
          errors.each do |error|
            if error.is_a? String
              @store[atr.name] << error
            else
              @store[atr.name].unshift({}) unless @store[atr.name].first.is_a?(Hash)
              @store[atr.name].first.deep_merge!(error)
            end
          end
        end
      end
      class Validator
        using Refinements

        attr_reader :instance

        def initialize(instance)
          @instance = instance
        end

        def self.validate(instance)
          new(instance).run
        end

        def run
          instance._attribute_store.each { |name, atr| validate_attribute(atr) }
          self
        end

        def error_store
          @error_store ||= ErrorStore.new#Hash.new { |hash, key| hash[key] = [] }
        end

        def errors
          error_store.store
        end

        private

        def validate_attribute(atr)
          if validations = atr.options[:validates]
            validations.each do |method, value|
              validate(atr, method, value)
            end
          else
            # TODO: Support nested Wardrobe instance???
            binding.pry
          # elsif atr_model?(attribute)
          #   result = @instance.send(name)._validate
          #   binding.pry
          #   errors[name] = result._validation_errors_hash unless result._valid?
          end
        end

        def validate(atr, method, value, **args)
          case method
          when :if then validate_if(atr, value, **args)
          when :and then validate_and(atr, value, **args)
          when :or then validate_or(atr, value, **args)
          else
            validate_other(atr, method, value, **args)
          end
        end

        def validate_other(atr, method, value, report_error: true)
          instance_value = instance.send(atr.name)
          begin
            error = if value.nil?
                      instance_value.send(method)
                    else
                      instance_value.send(method, value)
                    end
            error_store.add(atr, error) if error && report_error == true
            error
          rescue NoMethodError => e
            Wardrobe.logger.error("Prediciate #{method} not supported for #{instance_value.class}")
            raise e
          end
        end

        def validate_if(atr, value, **args)
          # binding.pry
        end

        def validate_or(atr, validations, **args)
          result = validations.map do |validation|
            validate_other(atr, *validation.to_a.first)
          end.compact
          if result.count == validations.count
            error_store.add(atr, *result)
          end
        end

        def validate_and(atr, validations, **args)
          result = validations.flat_map do |validation|
            validate(atr, *validation.to_a.first, report_error: false)
          end.compact
          error_store.add(atr, *result) if result.any?
        end
      end
    end
  end
end
