require 'test_helper'

class ValidationPredicatesEmptyTest < MiniTest::Test
  class Foo
    include Wardrobe
    plugin :validation
    attribute :string, String, validates { empty? }
    attribute :symbol, Symbol, validates { empty? }
    attribute :array, Array, validates { empty? }
    attribute :hash, Hash, validates { empty? }
    attribute :set, Set, validates { empty? }
  end

  def test_nil
    errors = Foo.new(
      string: nil, symbol: nil, array: nil, hash: nil, set: nil
    )._validation_errors

    refute errors.has_key?(:string)
    refute errors.has_key?(:symbol)
    refute errors.has_key?(:array)
    refute errors.has_key?(:hash)
    refute errors.has_key?(:set)
  end

  def test_with_content
    errors = Foo.new(
    string: 'Bar', symbol: :'Bar', array: ['Bar'], hash: {foo: 'Bar'}, set: Set.new(['Bar'])
    )._validation_errors

    assert_equal 'must be empty', errors[:string][0]
    assert_equal 'must be empty', errors[:symbol][0]
    assert_equal 'must be empty', errors[:array][0]
    assert_equal 'must be empty', errors[:hash][0]
    assert_equal 'must be empty', errors[:set][0]
  end
end
