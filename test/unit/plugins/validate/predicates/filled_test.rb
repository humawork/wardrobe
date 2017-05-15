require 'test_helper'

class ValidationPredicatesFilledTest < MiniTest::Test
  class Foo
    include Wardrobe
    plugin :validation
    attribute :string, String, validates { filled? }
    attribute :symbol, Symbol, validates { filled? }
    attribute :array, Array, validates { filled? }
    attribute :hash, Hash, validates { filled? }
    attribute :set, Set, validates { filled? }
  end

  def test_nil
    errors = Foo.new(
      string: nil, symbol: nil, array: nil, hash: nil, set: nil
    )._validation_errors

    assert_equal 'must be filled', errors[:string][0]
    assert_equal 'must be filled', errors[:symbol][0]
    assert_equal 'must be filled', errors[:array][0]
    assert_equal 'must be filled', errors[:hash][0]
    assert_equal 'must be filled', errors[:set][0]
  end

  def test_empty
    errors = Foo.new(
      string: '', symbol: :'', array: [], hash: {}, set: Set.new
    )._validation_errors

    assert_equal 'must be filled', errors[:string][0]
    assert_equal 'must be filled', errors[:symbol][0]
    assert_equal 'must be filled', errors[:array][0]
    assert_equal 'must be filled', errors[:hash][0]
    assert_equal 'must be filled', errors[:set][0]
  end

  def test_with_content
    errors = Foo.new(
      string: 'Bar', symbol: :'Bar', array: ['Bar'], hash: {foo: 'Bar'}, set: Set.new(['Bar'])
    )._validation_errors

    refute errors.has_key?(:string)
    refute errors.has_key?(:symbol)
    refute errors.has_key?(:array)
    refute errors.has_key?(:hash)
    refute errors.has_key?(:set)
  end
end
