require 'test_helper'

class DateCoercionTest < TestBase
  class DateObject
    include Wardrobe
    attribute :string,   Date
    attribute :date,     Date
    attribute :time,     Date
    attribute :datetime, Date
    attribute :integer,  Date
    attribute :float,    Date
  end

  def test_coercion
    time = Time.now.freeze
    date = time.to_date.freeze
    object = DateObject.new(
      string: date.to_s,
      date: date,
      time: time,
      datetime: time.to_datetime,
      integer: time.to_i,
      float: time.to_f
    )
    assert_equal date, object.string
    assert_equal date, object.date
    assert_equal date, object.time
    assert_equal date, object.datetime
    assert_equal date, object.integer
    assert_equal date, object.float
  end
end
