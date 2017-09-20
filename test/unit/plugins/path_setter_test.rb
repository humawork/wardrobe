require 'test_helper'

class PathSetterTest < TestBase
  class Foo
    include Wardrobe
    plugin :path_setter
    attribute :bar, String, path: 'this/is/a/0/nested'
    attribute :foo, String, path: 'foo/bar'
  end

  def test_path_setter_success
    foo = Foo.new({ this: { is: { a: [{ nested: 'thing'}]}}})
    assert_equal 'thing', foo.bar
  end

  def test_path_setter_missing
    foo = Foo.new({ this: { is: {}}})
    assert_nil foo.bar
  end

  def test_path_setter_missing_key
    foo = Foo.new({ this: { not: {}}})
    assert_nil foo.bar
  end

  def test_path_setter_string_in_array
    assert_raises(Wardrobe::Refinements::Path::PathError) do
      Foo.new({ this: []})
    end
  end

  def test_foo_conflict
    instance = Foo.new({ foo: { bar: 'Test'}})
    assert_equal 'Test', instance.foo
  end
end
