require 'test_helper'

class ValidationPredicatesEachTest < MiniTest::Test
  class Foo
    include Wardrobe
    plugin :validation
    attribute :simple, Array, validates { each? { int? } }
    attribute :advanced, Array, validates { array? & min_size?(4) & each? { int? & min_size?(4) } }
  end

  def test_nil
    errors = Foo.new(
      simple: nil,
      advanced: nil
    )._validation_errors

    refute errors.has_key?(:simple)
    assert_equal ['size cannot be less than 4'], errors[:advanced]
  end

  def test_with_content
    errors = Foo.new(
      simple: ['1','2'],
      advanced: ['1', '2']
    )._validation_errors

    assert_equal 1, errors[:simple].length
    assert_equal 2, errors[:advanced].length
    assert_equal ['must be a Integer'], errors[:simple].first[0]
    assert_equal ['must be a Integer', 'size cannot be less than 4'], errors[:advanced].first[0]
    assert_equal 'size cannot be less than 4', errors[:advanced].last
  end
end
