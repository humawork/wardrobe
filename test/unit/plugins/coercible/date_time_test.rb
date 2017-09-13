require 'test_helper'

class DateTimeCoercionTest < TestBase
  class DateTimeObject
    include Wardrobe
    attribute :string,         DateTime
    attribute :string_utc,     DateTime
    attribute :string_iso8601, DateTime
    attribute :time,           DateTime
    attribute :date,           DateTime
    attribute :datetime,       DateTime
    attribute :integer,        DateTime
    attribute :float,          DateTime
  end

  def test_coercion
    datetime = DateTime.now.freeze
    object = DateTimeObject.new(
      string: datetime.to_s,
      string_utc: datetime.dup.to_time.utc.to_s,
      string_iso8601: datetime.iso8601,
      datetime: datetime,
      time: datetime.to_time,
      date: datetime.to_date,
      integer: datetime.to_time.to_i,
      float: datetime.to_time.to_f
    )
    datetime_from_int = Time.at(datetime.to_time.to_i).to_datetime
    assert_equal datetime_from_int, object.string
    assert_equal datetime_from_int, object.string_utc
    assert_equal datetime_from_int, object.string_iso8601
    assert_equal datetime, object.time
    assert_equal datetime_from_int.to_date, object.date
    assert_equal datetime, object.datetime
    assert_equal Time.at(datetime.to_time.to_i).to_datetime, object.integer
    assert_equal Time.at(datetime.to_time.to_f).to_datetime, object.float
  end

  def test_error
    assert_raises Wardrobe::Refinements::Coercible::UnsupportedError do
      DateTimeObject.new(string: [])
    end
  end
end
