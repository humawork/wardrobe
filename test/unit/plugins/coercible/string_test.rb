require 'test_helper'

class StringCoercionTest < Minitest::Test
  class StringObject
    include Atrs
    attribute :string,  String
    attribute :symbol,  String
    attribute :integer, String
    attribute :float,   String
    attribute :nil,     String
  end

  def test_coercion
    object = StringObject.new(
      string: 'string',
      symbol: :a_symbol,
      integer: 123,
      float: 1.23,
      nil: nil
    )
    assert_equal 'string', object.string
    assert_equal 'a_symbol', object.symbol
    assert_equal '123', object.integer
    assert_equal '1.23', object.float
    assert_nil object.nil
  end

  def test_error
    assert_raises Atrs::Plugins::Coercible::Coercions::UnsupportedError do
      StringObject.new(string: [1,2])
    end
    assert_raises Atrs::Plugins::Coercible::Coercions::UnsupportedError do
      StringObject.new(symbol: Time.now)
    end
  end
end
