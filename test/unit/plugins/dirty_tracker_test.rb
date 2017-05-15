require 'test_helper'

class DirtyRoot
  include Wardrobe
  plugin :dirty_tracker
  attribute :depth, Integer
end

class DirtyTree
  include Wardrobe
  plugin :dirty_tracker
  attribute :name,     String
  attribute :branches, Hash
  attribute :leaves,   Array
  attribute :colors,   Set
  attribute :root,     DirtyRoot
  # TODO: Test sub wardrobe class
end

class DirtyTrackerTest < TestBase
  def setup
    @tree = DirtyTree.new(name: 'CleanTree', branches: {one: 'value'}, leaves: ['one'], colors: ['yellow', 'brown'], root: { depth: 5})
  end

  def test_string
    assert_equal 'CleanTree', @tree.name
    assert_equal false, @tree._changed?

    @tree.name = 'DirtyTree'

    assert_equal 'DirtyTree', @tree.name
    assert_equal true, @tree._changed?
  end

  def test_array
    assert_equal ['one'], @tree.leaves
    assert_equal false, @tree._changed?

    @tree.leaves.map(&:upcase)
    assert_equal false, @tree._changed?

    @tree.leaves.map!(&:upcase)
    assert_equal ['ONE'], @tree.leaves
    assert_equal true, @tree._changed?

    @tree.leaves << 'two'
    assert_equal ['ONE', 'two'], @tree.leaves
    assert_equal true, @tree._changed?
  end

  def test_hash
    hash = {one: 'value'}
    assert_equal hash, @tree.branches
    assert_equal false, @tree._changed?

    @tree.branches[:two] = 'another'
    hash = {one: 'value', two: 'another'}
    assert_equal hash, @tree.branches
    assert_equal true, @tree._changed?
  end

  def test_set
    assert_equal Set.new(['yellow', 'brown']), @tree.colors
    assert_equal false, @tree._changed?
    @tree.colors.add('yellow')
    assert_equal false, @tree._changed?
    @tree.colors.add('blue')
    assert_equal true, @tree._changed?
  end

  def test_sub_model
    assert_equal 5, @tree.root.depth
    assert_equal false, @tree._changed?
    @tree.root.depth = 3
    assert_equal true, @tree.root._changed?
    assert_equal true, @tree._changed?
  end
end
