require 'test_helper'

class BooleanCoercionTest < Minitest::Test
  class BooleanObject
    include Atrs
    attribute :true,         Atrs::Boolean
    attribute :false,        Atrs::Boolean
    attribute :integer_one,  Atrs::Boolean
    attribute :integer_zero, Atrs::Boolean
    attribute :yes,          Atrs::Boolean
    attribute :no,           Atrs::Boolean
    attribute :string_1,     Atrs::Boolean
    attribute :string_0,     Atrs::Boolean
    attribute :string_true,  Atrs::Boolean
    attribute :string_false, Atrs::Boolean
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
    object.integer_zero = 0
    assert_equal false, object.integer_zero
  end
end
