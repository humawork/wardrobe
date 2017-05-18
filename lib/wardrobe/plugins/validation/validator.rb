# frozen_string_literal: true

module Wardrobe
  module Plugins
    module Validation
      class Validator
        using Refinements
        attr_reader :value, :atr, :error_store, :validation

        def initialize(value, atr, error_store, validation = nil)
          @value = value
          @atr = atr
          @error_store = error_store
          @validation = validation || atr.options[:validates]
        end

        def run(report = true)
          if validation
            validate(validation, report)
          elsif value.respond_to?(:_validate!)
            if value._validation_errors.any?
              error_store.store[atr.name] = value._validation_errors
            end
          else
            Wardrobe.logger.warn("Unable to validate #{value.class.to_s} class")
          end
        end

        private

        def report(*errors)
          error_store.add(atr, *errors)
        end

        def validate(validation, report)
          if validation.type == :special#method[/^_.+_$/]
            send(*validation.args, report)
          else
            error = value.send(*validation.args)
            report && error ? report(error) : error
          end
        end

        def validate_list(validations, report)
          validations.map do |validation|
            validate(validation, report)
          end.compact
        end

        def each?(validation, report)
          errors = {}
          value.each_with_index do |item, index|
            result = Validator.new(item, nil, nil, validation).run(false)
            result = [result] unless result.is_a?(Array)
            errors[index] = result if result.any?
          end
          if errors.any?
            report(errors) if report
            errors
          end
        end

        def each_key?(validation, report)
          errors = {}
          value.each do |key, _|
            result = Validator.new(key, nil, nil, validation).run(false)
            result = [result] unless result.is_a?(Array)
            errors[key] = result.map { |error| 'key ' + error } if result.any?
          end
          if errors.any?
            report(errors) if report
            errors
          end
        end

        def each_value?(validation, report)
          errors = {}
          value.each do |key, val|
            result = Validator.new(val, nil, nil, validation).run(false)
            result = [result] unless result.is_a?(Array)
            errors[key] = result.map { |error| 'value ' + error } if result.any?
          end
          if errors.any?
            report(errors) if report
            errors
          end
        end

        def _or_(validations, report)
          errors = validate_list(validations, false)
          error_string = errors.join(' or ')
          report(error_string) if validations.size == errors.size && report
          error_string
        end

        def _and_(validations, report)
          errors = validate_list(validations, false)
          report ? report(*errors) : errors
        end

        def _then_(validations, report)
          error = validate(validations.first, false)
          if error
            report(error) if report
            error
          else
            validate_list(validations[1..-1], report)
          end
        end

        def _optional_(validation, report)
          validate(validation, report)
        rescue NoMethodError => e
          raise e unless value.nil?
        end
      end
    end
  end
end
