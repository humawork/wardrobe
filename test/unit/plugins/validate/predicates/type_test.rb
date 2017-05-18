require 'test_helper'

class ValidationPredicatesTypeTest < MiniTest::Test
  class Foo
    include Wardrobe(coerce: false)
    plugin :validation
    attribute :string, String, validates { str? }
    attribute :symbol, Symbol, validates { sym? }
    attribute :integer, Integer, validates { int? }
    attribute :float, Float, validates { float? }
    attribute :true, Wardrobe::Boolean, validates { bool? }
    attribute :false, Wardrobe::Boolean, validates { bool? }
    attribute :date, Date, validates { date? }
    attribute :time, Time, validates { time? }
    attribute :date_time, DateTime, validates { date_time? }
    attribute :array, Array, validates { array? }
    attribute :hash, Hash, validates { hash? }
  end

  def test_nil
    errors = Foo.new(
      string: nil, symbol: nil, integer: nil, float: nil, true: nil, false: nil,
      date: nil, time: nil, date_time: nil, array: nil, hash: nil
    )._validation_errors

    assert_equal 'must be a String', errors[:string][0]
    assert_equal 'must be a Symbol', errors[:symbol][0]
    assert_equal 'must be a Integer', errors[:integer][0]
    assert_equal 'must be a Float', errors[:float][0]
    assert_equal 'must be a TrueClass or FalseClass', errors[:true][0]
    assert_equal 'must be a TrueClass or FalseClass', errors[:false][0]
    assert_equal 'must be a Date', errors[:date][0]
    assert_equal 'must be a Time', errors[:time][0]
    assert_equal 'must be a DateTime', errors[:date_time][0]
    assert_equal 'must be a Array', errors[:array][0]
    assert_equal 'must be a Hash', errors[:hash][0]
  end

  def test_wrong_type
    errors = Foo.new(
      string: :sym, symbol: '', integer: '', float: '', true: '', false: '',
      date: '', time: '', date_time: '', array: '', hash: ''
    )._validation_errors

    assert_equal 'must be a String', errors[:string][0]
    assert_equal 'must be a Symbol', errors[:symbol][0]
    assert_equal 'must be a Integer', errors[:integer][0]
    assert_equal 'must be a Float', errors[:float][0]
    assert_equal 'must be a TrueClass or FalseClass', errors[:true][0]
    assert_equal 'must be a TrueClass or FalseClass', errors[:false][0]
    assert_equal 'must be a Date', errors[:date][0]
    assert_equal 'must be a Time', errors[:time][0]
    assert_equal 'must be a DateTime', errors[:date_time][0]
    assert_equal 'must be a Array', errors[:array][0]
    assert_equal 'must be a Hash', errors[:hash][0]
  end

  def test_correct_types
    errors = Foo.new(
      string: '', symbol: :sym, integer: 1, float: 1.1, true: true,
      false: false, date: Time.now.to_date, time: Time.now,
      date_time: Time.now.to_datetime, array: [], hash: {}
    )._validation_errors

    refute errors.has_key? :string
    refute errors.has_key? :symbol
    refute errors.has_key? :integer
    refute errors.has_key? :float
    refute errors.has_key? :true
    refute errors.has_key? :false
    refute errors.has_key? :date
    refute errors.has_key? :time
    refute errors.has_key? :date_time
    refute errors.has_key? :array
    refute errors.has_key? :hash
  end
end
