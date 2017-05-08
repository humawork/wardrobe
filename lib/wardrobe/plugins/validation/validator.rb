# frozen_string_literal: true

module Wardrobe
  module Plugins
    module Validation
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

        def errors
          @errors ||= Hash.new { |hash, key| hash[key] = [] }
        end

        private

        def validate_attribute(atr)
          if validations = atr.options[:validates]
            validations.each { |method, value| validate(atr, method, value)}
          else
            binding.pry
          # elsif atr_model?(attribute)
          #   result = @instance.send(name)._validate
          #   binding.pry
          #   errors[name] = result._validation_errors_hash unless result._valid?
          end
        end

        # def atr_model?(atr)
        #   atr.options.klass.respond_to?(:attribute_store) &&
        #     @instance.send(atr.name).respond_to?(:_validate!)
        # end

        # def validate_validation(atr_name, validation, log_error: true)
        #   validation.map do |method, value|
        #     validate_one(atr_name, method, value, log_error: log_error)
        #   end
        # end

        def validate(atr, method, value)
          case method
          when :if then validate_if(atr, value)
          when :and then validate_and(atr, value)
          when :or then validate_or(atr, value)
          else
            if error = validate_other(atr, method, value)
              errors[atr.name] << error
            end
          end
        end

        def validate_other(atr, method, value)
          instance.send(atr.name).send(method, value)
        end

        def validate_if(atr, value)
          # binding.pry
        end

        def validate_and(atr, validations)
          result = validations.map do |validation|
            validate_other(atr, *validation.to_a.first)
          end.compact
          errors[atr.name].push(*result) if result.any?
        end

        def validate_one(atr_name, method, value, log_error: true)
          case method
          when :if
            value.map do |validation|

            end
            binding.pry
          when :and
            value.each do |part|

            end
            binding.pry
          when :or
            result = value.flat_map do |validation|
              validate_validation(atr_name, validation, log_error: false)
            end
            binding.pry
            unless result.any? { |item| item[0] }
              errors[atr_name].unshift(*(result.select{ |res| res[0] == false }.map{ |error| error[1] }))
            end
          else
            if error = instance.send(atr_name).send(method, value)
              errors[atr_name] << error if error
            end
          end
        end
      end
    end
  end
end
