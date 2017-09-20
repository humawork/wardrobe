require 'test_helper'

class PathSetterTest < TestBase
  class Testing
    include Wardrobe
    plugin :path_setter
    attribute :bar, String, path: 'this/is/a/0/nested'
    attribute :foo, String, path: 'foo/bar'
  end

  def test_path_setter_success
    foo = Testing.new({ this: { is: { a: [{ nested: 'thing'}]}}})
    assert_equal 'thing', foo.bar
  end

  def test_path_setter_missing
    foo = Testing.new({ this: { is: {}}})
    assert_nil foo.bar
  end

  def test_path_setter_missing_key
    foo = Testing.new({ this: { not: {}}})
    assert_nil foo.bar
  end

  def test_path_setter_string_in_array
    assert_raises(Wardrobe::Refinements::Path::PathError) do
      Testing.new({ this: []})
    end
  end

  def test_foo_conflict
    instance = Testing.new({ foo: { bar: 'Test'}})
    assert_equal 'Test', instance.foo
  end

  def test_non_path_init
    instance = Testing.new(bar: 'Aye', foo: 'Nay')
    assert_equal 'Aye', instance.bar
    assert_equal 'Nay', instance.foo
  end
end
