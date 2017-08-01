require 'test_helper'

class ValidationPredicatesMinSizeTest < MiniTest::Test
  class Foo
    include Wardrobe
    plugin :validation

    attribute :array,  Array,  validates { min_size?(1) }
    attribute :hash,   Hash,   validates { min_size?(1) }
    attribute :set,    Set,    validates { min_size?(1) }
    attribute :string, String, validates { min_size?(1) }
    attribute :symbol, Symbol, validates { min_size?(1) }
  end

  def test_nil
    assert_raises(NoMethodError) {
      Foo.new(
        array: nil, hash: nil, set: nil, string: nil, symbol: nil
      )._validation_errors
    }
  end

  def test_fail
    errors = Foo.new(
      array: [], hash: {}, set: Set.new, string: '', symbol: :''
    )._validation_errors

    assert_equal 'size cannot be less than 1', errors[:array][0]
    assert_equal 'size cannot be less than 1', errors[:hash][0]
    assert_equal 'size cannot be less than 1', errors[:set][0]
    assert_equal 'size cannot be less than 1', errors[:string][0]
    assert_equal 'size cannot be less than 1', errors[:symbol][0]
  end

  def test_success
    errors = Foo.new(
      array: [1], hash: { 1 => 2 }, set: Set.new([1]), string: '1', symbol: :a
    )._validation_errors

    refute errors.has_key?(:array)
    refute errors.has_key?(:hash)
    refute errors.has_key?(:set)
    refute errors.has_key?(:string)
    refute errors.has_key?(:symbol)
  end
end
