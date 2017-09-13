require 'test_helper'

class IntegerCoercionTest < TestBase
  class IntegerObject
    include Wardrobe
    attribute :integer,      Integer
    attribute :float,        Integer
    attribute :string,       Integer
    attribute :string_float, Integer
    attribute :time,         Integer
    attribute :datetime,     Integer
    attribute :date,         Integer
  end

  def test_coercion
    now = Time.now.freeze

    object = IntegerObject.new(
      integer: 1,
      float: 100.01,
      string: '1001',
      string_float: '1002.002',
      time: now,
      datetime: now.to_datetime,
      date: now.to_date
    )

    assert_equal 100, object.float
    assert_equal 1001, object.string
    assert_equal 1002, object.string_float
    assert_equal 1, object.integer
    assert_equal now.to_i, object.time
    assert_equal now.to_i, object.datetime
    assert_equal now.to_date.to_time.to_i, object.date
  end

  def test_error
    assert_raises Wardrobe::Refinements::Coercible::UnsupportedError do
      IntegerObject.new(integer: [])
    end
  end
end
