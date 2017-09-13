require 'test_helper'

class BooleanCoercionTest < TestBase
  class BooleanObject
    include Wardrobe
    attribute :true,         Wardrobe::Boolean
    attribute :false,        Wardrobe::Boolean
    attribute :integer_one,  Wardrobe::Boolean
    attribute :integer_zero, Wardrobe::Boolean
    attribute :yes,          Wardrobe::Boolean
    attribute :no,           Wardrobe::Boolean
    attribute :string_1,     Wardrobe::Boolean
    attribute :string_0,     Wardrobe::Boolean
    attribute :string_true,  Wardrobe::Boolean
    attribute :string_false, Wardrobe::Boolean
  end

  def test_coercion_to_true
    object = BooleanObject.new(
      true: true,
      integer_one: 1,
      yes: 'yes',
      string_1: '1',
      string_true: 'true'
    )

    assert_equal true, object.true
    assert_equal true, object.integer_one
    assert_equal true, object.yes
    assert_equal true, object.string_1
    assert_equal true, object.string_true
  end

  def test_coercion_to_false
    object = BooleanObject.new(
      false: false,
      integer_zero: 0,
      no: 'no',
      string_0: '0',
      string_false: 'false'
    )
    assert_equal false, object.false
    assert_equal false, object.integer_zero
    assert_equal false, object.no
    assert_equal false, object.string_0
    assert_equal false, object.string_false
  end

  def test_coercion_from_setter
    object = BooleanObject.new
    object.false = false
    object.integer_zero = 0
    assert_equal false, object.false
    assert_equal false, object.integer_zero
  end

  def test_error
    assert_raises Wardrobe::Refinements::Coercible::UnsupportedError do
      BooleanObject.new(yes: 'ja')
    end
    assert_raises Wardrobe::Refinements::Coercible::UnsupportedError do
      BooleanObject.new(yes: 11)
    end
    assert_raises Wardrobe::Refinements::Coercible::UnsupportedError do
      BooleanObject.new(yes: [1])
    end
  end
end
