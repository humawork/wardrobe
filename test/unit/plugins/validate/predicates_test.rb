require 'test_helper'

class ValidationPredicatesTest < TestBase
  class Foo
    include Wardrobe
    plugin :validation
    attribute :or, String, validates { optional { size?(1) | format?(/a/) }}
    attribute :and, String, validates { optional { size?(1) & format?(/and/) }}
    attribute :then, String, validates { optional { min_size?(10) > format?(/Lorem ipsum/) }}
    attribute :or_advanced, String, validates {
      optional {
        (size?(1) | format?(/a/) | size?(1..2)) &
        (format?(/abc/) | format?(/aaa/))
      }
    }
  end

  def test_or
    errors = Foo.new(
      or: 'Lorem ipsum...'
    )._validation_errors

    assert_equal 1, errors[:or].length
    assert_equal 'size must be 1 or must match /a/', errors[:or].first
  end

  def test_and
    errors = Foo.new(
      and: 'Lorem ipsum...'
    )._validation_errors

    assert_equal 2, errors[:and].length
    assert_equal 'size must be 1', errors[:and].first
    assert_equal 'must match /and/', errors[:and].last
  end


  def test_or_advanced
    errors = Foo.new(
      or_advanced: 'Lorem ipsum...',
    )._validation_errors

    assert_equal 2, errors[:or_advanced].length
    assert_equal 'size must be 1 or must match /a/ or size must be within 1 - 2', errors[:or_advanced].first
    assert_equal 'must match /abc/ or must match /aaa/', errors[:or_advanced].last
  end

  def test_then_success
    errors = Foo.new(
      then: 'Lorem ipsum...',
    )._validation_errors

    refute errors.has_key?(:then)
  end

  def test_then_error_before
    errors = Foo.new(
      then: 'Lorem',
    )._validation_errors

    assert_equal 1, errors[:then].length
    assert_equal 'size cannot be less than 10', errors[:then].first
  end

  def test_then_error_after
    errors = Foo.new(
      then: 'Lorem Lorem Lorem',
    )._validation_errors

    assert_equal 1, errors[:then].length
    assert_equal 'must match /Lorem ipsum/', errors[:then].first
  end
end
