require 'test_helper'

class MergeTest < TestBase
  class Foo
    include Wardrobe
    plugin :merge
    attribute :string, String
    attribute :hash,   Hash
    attribute :array,  Array
  end

  class Bar < Foo
    attribute :child,  Foo
  end

  def setup
    @a = Bar.new(
      string: 'a',
      hash: { 1 => 'a',  2 => 'a'},
      array: ['a0', 'a1'],
      child: {
        string: 'a',
        hash: {
          1 => 2,
          hash: { a: true, nested: { c: 3 }}
        }
      }
    )
    @b = Bar.new(
      string: 'b',
      hash: { 1 => 'b',  2 => 'b'},
      array: ['b0', 'b1'],
      child: {
        string: 'b',
        hash: {
          3 => 4,
          hash: { b: true, nested: { d: 4 }}
        }
      }
    )
  end

  def test_merge
    merged = @a.merge(@b)
    assert_equal 'b', merged.string
    assert_equal 'b', merged.hash[1]
    assert_equal 'b', merged.hash[2]
    assert_equal ['b0', 'b1'], merged.array
    assert_equal 'b', merged.child.string
    assert_equal({ 1 => 2, 3 => 4, hash: { b: true, nested: { d: 4 }}}, merged.child.hash)
  end

  def test_deep_merge
    merged = @a.deep_merge(@b)
    assert_equal 'b', merged.string
    assert_equal 'b', merged.hash[1]
    assert_equal 'b', merged.hash[2]
    assert_equal ['b0', 'b1'], merged.array
    assert_equal 'b', merged.child.string
    assert_equal({ 1 => 2, 3 => 4, hash: { a: true, b: true, nested: { c: 3, d: 4 }}}, merged.child.hash)
  end
end
