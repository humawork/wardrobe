module Attributable
  module Plugins
    module Validations
      class Validator
        using Refinements

        attr_reader :instance

        def initialize(instance)
          @instance = instance
        end

        def run
          attribute_set.each do |name, options|
            if options.respond_to?(:validates)
              validate_validations(name, options.validates)
            elsif validateable?(name, options)
              result = @instance.send(name)._validate!
              instance._validation_errors[name] = result._validation_errors unless result._valid?
            end
          end
        end

        private

        def validateable?(name, options)
          options.klass.respond_to?(:attribute_set) &&
            @instance.send(name).respond_to?(:_validate!)
        end

        def attribute_set
          instance._attribute_set
        end

        def validate_validations(atr_name, validations, log_error: true)
          validations.map do |method, value|
            validate(atr_name, method, value, log_error: log_error)
          end
        end

        def validate(atr_name, method, value, log_error: true)
          case method
          when :or
            result = value.flat_map do |validations|
              validate_validations(atr_name, validations, log_error: false)
            end
            unless result.any? { |item| item[0] }
              instance._validation_errors[atr_name].unshift(*(result.select{ |res| res[0] == false }.map{ |error| error[1] }))
            end
          else
            status, error = instance.send(atr_name).send(method, value)
            instance._validation_errors[atr_name] << error if error && log_error
            [status, error]
          end
        end
      end
    end
  end
end
