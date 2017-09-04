# frozen_string_literal: true

module Wardrobe
  module Plugins
    module Validation
      class Validator
        using Refinements
        attr_reader :value, :atr, :error_store, :validation, :log

        def initialize(value, atr, error_store = ErrorStore.new, validation = nil)
          @value = value
          @atr = atr
          @error_store = error_store
          @validation = validation || atr.options[:validates]
          @log = true
        end

        def run(report = true)
          if validation && validation.any?
            validate(validation, report)
          elsif value.respond_to?(:_validate!)
            if value._validation_errors.any?
              error_store.store[atr.name] = value._validation_errors
            end
          elsif atr.klass.is_a?(Array) && value.first&.respond_to?(:_validate!)
            errors = {}
            value.each_with_index do |item, index|
              if item._validation_errors.any?
                errors[index] = item._validation_errors
              end
            end
            if errors.any?
              report(errors) if report
              errors
            end
          end
        end

        private

        def report(*errors)
          error_store.add(atr, *errors)
        end

        def validate(validation, report)
          if validation.type == :special
            send(*validation.args, report)
          else
            begin
              error = value.send(*validation.args)
            rescue NoMethodError => e
              log_unable_to_validate_message(validation[:method]) if log
              raise e
            end
            report && error ? report(error) : error
          end
        end

        def disable_log
          @log = false
          yield
        ensure
          @log = true
        end

        def log_unable_to_validate_message(method)
          Wardrobe.logger.error("Unable to validate #{method} on #{value.class}")
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
            errors[key] = result.map { |error| 'KEY: ' + error } if result.any?
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
            errors[key] = result.map { |error| 'VALUE: ' + error } if result.any?
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
          disable_log do
            validate(validation, report)
          end
        rescue NoMethodError => e
          unless value.nil?
            log_unable_to_validate_message(validation[:method])
            raise e
          end
        end
      end
    end
  end
end
