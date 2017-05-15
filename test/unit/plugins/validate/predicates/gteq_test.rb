require 'test_helper'

class ValidationPredicatesGreaterThanOrEqualToTest < MiniTest::Test
  class Foo
    include Wardrobe
    plugin :validation
    attribute :integer, Integer, validates { gteq?(1) }
    attribute :float, Float, validates { gteq?(1.0) }
  end

  def test_nil
    assert_raises(NoMethodError) {
      Foo.new(
        integer: nil, float: nil
      )._validation_errors
    }
  end

  def test_fail
    errors = Foo.new(
      integer: 0, float: 0.9
    )._validation_errors

    assert_equal 'must be greater than or equal to 1', errors[:integer][0]
    assert_equal 'must be greater than or equal to 1.0', errors[:float][0]
  end

  def test_success
    errors = Foo.new(
      integer: 1, float: 1.0
    )._validation_errors

    refute errors.has_key?(:integer)
    refute errors.has_key?(:float)
  end
end
