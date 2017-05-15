require 'test_helper'

class TimeCoercionTest < TestBase
  class TimeObject
    include Wardrobe
    attribute :string,         Time
    attribute :string_utc,     Time
    attribute :string_iso8601, Time
    attribute :time,           Time
    attribute :date,           Time
    attribute :datetime,       Time
    attribute :integer,        Time
    attribute :float,          Time
  end

  def test_coercion
    time = Time.now.freeze
    object = TimeObject.new(
      string: time.to_s,
      string_utc: time.dup.utc.to_s,
      string_iso8601: time.iso8601,
      time: time,
      date: time.to_date,
      datetime: time.to_datetime,
      integer: time.to_i,
      float: time.to_f
    )
    assert_equal time.to_i, object.string.to_i
    assert_equal time.to_i, object.string_utc.to_i
    assert_equal time.to_i, object.string_iso8601.to_i
    assert_equal time, object.time
    assert_equal time.to_date.to_time, object.date
    assert_equal time, object.datetime
    assert_equal Time.at(time.to_i), object.integer
    assert_equal Time.at(time.to_f), object.float
  end
end
