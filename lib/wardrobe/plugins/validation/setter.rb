# frozen_string_literal: true

module Wardrobe
  module Plugins
    module Validation
      Wardrobe.register_setter(
        name: :validate,
        before: [:setter],
        setter: lambda do |value, atr, instance, _options|
          return value if instance._initializing?
          errors = Validator.new(value, atr).run
          raise ValidationError.new(errors) unless errors.empty?
          value
        end
      )
    end
  end
end
