require 'test_helper'

class OptionalSetterTest < TestBase
  class Foo
    include Wardrobe
    plugin :optional_setter
    attribute :bar, String, setter: false
  end

  def test_optinal_setter
    foo = Foo.new(bar: 'value')
    assert_equal 'value', foo.bar
    assert_raises(NoMethodError) do
      foo.bar = 'changed'
    end
  end
end
