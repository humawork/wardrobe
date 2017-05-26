require 'test_helper'

class DisableCoercionTest < TestBase
  class Foo
    include Wardrobe
    attribute :bar, Symbol, coerce: false
  end

  def test_coercion
    object = Foo.new(
      bar: 'a_symbol'
    )
    assert_equal 'a_symbol', object.bar
  end
end
