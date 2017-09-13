require 'test_helper'

class SymbolCoercionTest < TestBase
  class SymbolObject
    include Wardrobe
    attribute :symbol,  Symbol
    attribute :string,  Symbol
    attribute :nil,     Symbol
  end

  def test_coercion
    object = SymbolObject.new(
      symbol: :a_symbol,
      string: 'a_string',
      nil: nil
    )
    assert_equal :a_symbol, object.symbol
    assert_equal :a_string, object.string
    assert_nil object.nil
  end

  def test_error
    assert_raises Wardrobe::Refinements::Coercible::UnsupportedError do
      SymbolObject.new(string: [1,2])
    end
    assert_raises Wardrobe::Refinements::Coercible::UnsupportedError do
      SymbolObject.new(symbol: Time.now)
    end
  end
end
