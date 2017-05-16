require 'test_helper'

class ValidationNestedModelTest < TestBase
  class FooWithValidation
    include Wardrobe
    plugin :validation
    attribute :name, String, validates { size?(1) }
  end

  class FooWithoutValidation
    include Wardrobe
    attribute :name, String
  end

  class Bar
    include Wardrobe
    plugin :validation
    attribute :name, String, validates { size?(1) }
    attribute :foo_with, FooWithValidation
    attribute :foo_without, FooWithoutValidation
  end

  def test_nested_models
    errors = Bar.new(
      name: 'Bar With Validation',
      foo_with: {
        name: 'Foo With Validation'
      },
      foo_without: {
        name: 'Foo Without Validation'
      }
    )._validation_errors

    assert_equal 2, errors.length
    assert_equal ['size must be 1'], errors[:name]
    assert_equal ['size must be 1'], errors[:foo_with][:name]
    assert_equal 1, log_messages.length
    refute errors.has_key?(:foo_without)
  end
end
