require 'test_helper'

class LastSetAttributeTest < TestBase
  class Foo
    include Wardrobe
    plugin :last_set_attribute
    attribute :one, String
    attribute :two, String
    attribute :three, String
  end

  def setup
    @foo = Foo.new(
      one: 'One',
      three: 'Three'
    )
    @foo.two = 'Two'
  end

  def test_foo
    assert_equal 'One', @foo.one
    assert_equal 'Two', @foo.two
    assert_equal 'Three', @foo.three

    assert_equal :two, @foo._last_set_attribute

    @foo.one = '1'
    assert_equal :one, @foo._last_set_attribute
    assert_equal '1', @foo.one

    @foo.three = '3'
    assert_equal :three, @foo._last_set_attribute
    assert_equal '3', @foo.three
  end
end
