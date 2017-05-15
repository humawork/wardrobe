require 'test_helper'

class FlaotCoercionTest < TestBase
  class FloatObject
    include Wardrobe
    attribute :float,    Float
    attribute :string,   Float
    attribute :integer,  Float
    attribute :time,     Float
    attribute :datetime, Float
    attribute :date,     Float
  end

  def test_coercion
    now = Time.now.freeze

    object = FloatObject.new(
      float: 1.01,
      string: '1.02',
      integer: 1,
      time: now,
      datetime: now.to_datetime,
      date: now.to_date
    )

    assert_equal 1.01, object.float
    assert_equal 1.02, object.string
    assert_equal 1.0, object.integer
    assert_equal now.to_f, object.time
    assert_equal now.to_f, object.datetime
    assert_equal now.to_date.to_time.to_f, object.date
  end
end
