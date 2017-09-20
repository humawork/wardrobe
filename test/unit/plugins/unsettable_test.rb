require 'test_helper'

class UnsettableTest < TestBase
  class Foo
    include Wardrobe
    plugin :unsettable
    attribute :bar, String, unsettable: true
  end

  def test_unsettable
    foo = Foo.new(bar: 'value')
    assert_raises(NoMethodError) do
      foo.bar
    end
    assert_raises(NoMethodError) do
      foo.bar = 'changed'
    end
  end
end
