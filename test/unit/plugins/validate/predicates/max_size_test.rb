require 'test_helper'

class ValidationPredicatesMaxSizeTest < MiniTest::Test
  class Foo
    include Wardrobe
    plugin :validation

    attribute :array,  Array,  validates { max_size?(1) }
    attribute :hash,   Hash,   validates { max_size?(1) }
    attribute :set,    Set,    validates { max_size?(1) }
    attribute :string, String, validates { max_size?(1) }
  end

  def test_nil
    assert_raises(NoMethodError) {
      Foo.new(
        array: nil, hash: nil, set: nil, string: nil
      )._validation_errors
    }
  end

  def test_fail
    errors = Foo.new(
    array: [1, 2], hash: { 1 => 2, 3 => 4 }, set: Set.new([1, 2]), string: '12'
    )._validation_errors

    assert_equal 'size cannot be greater than 1', errors[:array][0]
    assert_equal 'size cannot be greater than 1', errors[:hash][0]
    assert_equal 'size cannot be greater than 1', errors[:set][0]
    assert_equal 'size cannot be greater than 1', errors[:string][0]
  end

  def test_success
    errors = Foo.new(
      array: [], hash: {}, set: Set.new, string: ''
    )._validation_errors

    refute errors.has_key?(:array)
    refute errors.has_key?(:hash)
    refute errors.has_key?(:set)
    refute errors.has_key?(:string)
  end
end
