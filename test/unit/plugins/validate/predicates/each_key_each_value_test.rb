require 'test_helper'

class ValidationPredicatesEachKeyTest < MiniTest::Test
  class Foo
    include Wardrobe
    plugin :validation
    attribute :simple, Hash, validates { each_key? { int? } }
    attribute :advanced, Hash, validates { array? & min_size?(4) & each_key? { int? } & each_value? { sym? } }
  end

  def test_nil
    errors = Foo.new(
      simple: nil,
      advanced: nil
    )._validation_errors

    refute errors.has_key?(:simple)
    assert_equal ['must be a Array', 'size cannot be less than 4'], errors[:advanced]
  end

  def test_with_content
    errors = Foo.new(
      simple: { one: 1, two: 2 },
      advanced: { one: 1, two: 2 }
    )._validation_errors

    assert_equal 1, errors[:simple].length
    assert_equal 3, errors[:advanced].length
    assert_equal ['key must be a Integer'], errors[:simple].first[:one]
    assert_equal ['key must be a Integer', 'value must be a Symbol'], errors[:advanced].first[:one]
    assert_equal 'must be a Array', errors[:advanced][1]
    assert_equal 'size cannot be less than 4', errors[:advanced].last
  end
end
