require 'test_helper'

class ValidationPredicatesFormatTest < MiniTest::Test
  class Foo
    include Wardrobe(coerce: false)
    plugin :validation
    attribute :string, String, validates { format?(/^abc$/) }
    attribute :symbol, Symbol, validates { format?(/^abc$/) }
  end

  def test_failin_regex
    errors = Foo.new(
      string: 'no', symbol: :no
    )._validation_errors

    assert_equal 'is in invalid format', errors[:string][0]
    assert_equal 'is in invalid format', errors[:symbol][0]
  end

  def test_matching_regex
    errors = Foo.new(
      string: 'abc', symbol: :abc
    )._validation_errors

    refute errors.has_key?(:string)
    refute errors.has_key?(:symbol)
  end
end
