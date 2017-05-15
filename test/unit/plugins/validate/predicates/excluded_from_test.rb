require 'test_helper'

class ValidationPredicatesExludedFromTest < MiniTest::Test
  TIME = Time.now
  class Foo
    include Wardrobe(coerce: false)
    plugin :validation
    attribute :string,    String,   validates { excluded_from?(['test']) }
    attribute :symbol,    Symbol,   validates { excluded_from?([:test]) }
    attribute :integer,   Integer,  validates { excluded_from?([1]) }
    attribute :float,     Float,    validates { excluded_from?([1.1]) }
    attribute :boolean,   Wardrobe::Boolean, validates { excluded_from?([true]) }
    attribute :date,      Date,     validates { excluded_from?([TIME.to_date]) }
    attribute :time,      Time,     validates { excluded_from?([TIME]) }
    attribute :date_time, DateTime, validates { excluded_from?([TIME.to_datetime]) }
    attribute :array,     Array,    validates { excluded_from?([[1]]) }
    attribute :hash,      Hash,     validates { excluded_from?([{one: 1}]) }
  end

  def test_nil
    errors = Foo.new(
      string: nil, symbol: nil, integer: nil, float: nil, boolean: nil,
      date: nil, time: nil, date_time: nil, array: nil, hash: nil
    )._validation_errors

    refute errors.has_key? :string
    refute errors.has_key? :symbol
    refute errors.has_key? :integer
    refute errors.has_key? :float
    refute errors.has_key? :boolean
    refute errors.has_key? :date
    refute errors.has_key? :time
    refute errors.has_key? :date_time
    refute errors.has_key? :array
    refute errors.has_key? :hash
  end

  def test_with_values
    errors = Foo.new(
      string: 'test', symbol: :test, integer: 1, float: 1.1, boolean: true,
      date: TIME.to_date, time: TIME, date_time: TIME.to_datetime, array: [1], hash: {one: 1}
    )._validation_errors

    assert_equal 'must not be one of: "test"', errors[:string][0]
    assert_equal 'must not be one of: :test', errors[:symbol][0]
    assert_equal 'must not be one of: 1', errors[:integer][0]
    assert_equal 'must not be one of: 1.1', errors[:float][0]
    assert_equal 'must not be one of: true', errors[:boolean][0]
    assert_equal "must not be one of: #{TIME.to_date.to_s}", errors[:date][0]
    assert_equal "must not be one of: #{TIME.to_s}", errors[:time][0]
    assert_equal "must not be one of: #{TIME.to_datetime.to_s}", errors[:date_time][0]
    assert_equal 'must not be one of: [1]', errors[:array][0]
    assert_equal 'must not be one of: {:one=>1}', errors[:hash][0]
  end
end
