require 'test_helper'

class BooleanCoercionTest < Minitest::Test
  class BooleanObject
    extend Atrs
    attribute :true, Atrs::Boolean
    attribute :false, Atrs::Boolean
    attribute :one, Atrs::Boolean
    attribute :zero, Atrs::Boolean
    attribute :yes, Atrs::Boolean
    attribute :no, Atrs::Boolean
    attribute :string_1, Atrs::Boolean
    attribute :string_0, Atrs::Boolean
    attribute :string_true, Atrs::Boolean
    attribute :string_false, Atrs::Boolean
  end

  def test_coercions
    object = BooleanObject.new(
      true: true, false: false, one: 1, zero: 0, yes: 'yes', no: 'no',
      string_1: '1', string_0: '0', string_true: 'true', string_false: 'false'
    )
    assert_equal true, object.true
    assert_equal false, object.false
    assert_equal true, object.one
    assert_equal false, object.zero
    assert_equal true, object.yes
    assert_equal false, object.no
    assert_equal true, object.string_1
    assert_equal false, object.string_0
    assert_equal true, object.string_true
    assert_equal false, object.string_false
  end
end
