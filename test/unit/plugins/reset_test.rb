require 'test_helper'

class ResetTest < TestBase
  class Foo
    include Wardrobe
    plugin :default
    plugin :reset
    attribute :name, String, default: 'Default String'
    attribute :hash, Hash
    attribute :array, Array
  end

  class Bar
    include Wardrobe
    plugin :reset
    attribute :name, String
    attribute :child, Foo, init_if_nil: true
  end

  def setup
    @foo = Foo.new(
      name: 'Foo',
      hash: { foo: :bar },
      array: [1,2]
    )
    @bar = Bar.new(
      name: 'Bar',
      child: {
        name: 'Child',
        hash: { foo: :bar_child },
        array: [3,4]
      }
    )
  end

  def test_foo_reset!
    before_reset_object_id = @foo.object_id
    assert_equal 'Foo', @foo.name
    assert_equal({foo: :bar}, @foo.hash)
    assert_equal [1,2], @foo.array
    @foo._reset!
    assert_equal 'Default String', @foo.name
    assert_equal({}, @foo.hash)
    assert_equal [], @foo.array
    assert_equal before_reset_object_id, @foo.object_id
  end

  def test_foo_reset
    before_reset_object_id = @foo.object_id
    assert_equal 'Foo', @foo.name
    assert_equal({foo: :bar}, @foo.hash)
    assert_equal [1,2], @foo.array
    reseted_foo = @foo._reset
    assert_equal 'Default String', reseted_foo.name
    assert_equal({}, reseted_foo.hash)
    assert_equal [], reseted_foo.array
    refute_equal before_reset_object_id, reseted_foo.object_id
  end

  def test_bar_reset!
    before_reset_object_id = @bar.object_id
    assert_equal 'Bar', @bar.name
    assert_equal 'Child', @bar.child.name
    assert_equal({foo: :bar_child}, @bar.child.hash)
    assert_equal [3,4], @bar.child.array
    @bar._reset!
    assert_nil @bar.name
    assert_equal 'Default String', @bar.child.name
    assert_equal({}, @bar.child.hash)
    assert_equal [], @bar.child.array
    assert_equal before_reset_object_id, @bar.object_id
  end

  def test_bar_reset
    before_reset_object_id = @bar.object_id
    assert_equal 'Bar', @bar.name
    assert_equal 'Child', @bar.child.name
    assert_equal({foo: :bar_child}, @bar.child.hash)
    assert_equal [3,4], @bar.child.array
    reseted_bar = @bar._reset
    assert_nil reseted_bar.name
    assert_equal 'Default String', reseted_bar.child.name
    assert_equal({}, reseted_bar.child.hash)
    assert_equal [], reseted_bar.child.array
    refute_equal before_reset_object_id, reseted_bar.object_id
  end
end
