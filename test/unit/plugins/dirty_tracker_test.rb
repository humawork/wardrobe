require 'test_helper'

class DirtyRoot
  include Wardrobe
  plugin :dirty_tracker
  attribute :depth, Integer
end

class DirtyTree
  include Wardrobe
  plugin :dirty_tracker
  attribute :name,                String
  attribute :branches,            Hash
  attribute :leaves,              Array
  attribute :colors,              Set
  attribute :root,                DirtyRoot
  attribute :array_of_roots,      Array[DirtyRoot]
  attribute :hash_of_symbol_root, Hash[Symbol => DirtyRoot]
  attribute :hash_of_root_symbol, Hash[DirtyRoot => Symbol]
end

class DirtyTrackerTest < TestBase
  def setup
    @tree = DirtyTree.new(
      name: 'CleanTree',
      branches: {one: 'value'},
      leaves: ['one'],
      colors: ['yellow', 'brown'],
      root: { depth: 5},
      array_of_roots: [{depth: 1}, {depth: 2}],
      hash_of_symbol_root: { one: { depth: 1}},
      hash_of_root_symbol: {{ depth: 1} => :one}
    )
  end

  def test_string
    assert_equal 'CleanTree', @tree.name
    assert_equal false, @tree._dirty?

    @tree.name = 'DirtyTree'

    assert_equal 'DirtyTree', @tree.name
    assert_equal true, @tree._dirty?
  end

  def test_array
    assert_equal ['one'], @tree.leaves
    assert_equal false, @tree._dirty?

    @tree.leaves.map(&:upcase)
    assert_equal false, @tree._dirty?

    @tree.leaves.map!(&:upcase)
    assert_equal ['ONE'], @tree.leaves
    assert_equal true, @tree._dirty?

    @tree.leaves << 'two'
    assert_equal ['ONE', 'two'], @tree.leaves
    assert_equal true, @tree._dirty?
  end

  def test_hash
    hash = {one: 'value'}
    assert_equal hash, @tree.branches
    assert_equal false, @tree._dirty?

    @tree.branches[:two] = 'another'
    hash = {one: 'value', two: 'another'}
    assert_equal hash, @tree.branches
    assert_equal true, @tree._dirty?
  end

  def test_set
    assert_equal Set.new(['yellow', 'brown']), @tree.colors
    assert_equal false, @tree._dirty?
    @tree.colors.add('yellow')
    assert_equal false, @tree._dirty?
    @tree.colors.add('blue')
    assert_equal true, @tree._dirty?
  end

  def test_sub_model
    assert_equal 5, @tree.root.depth
    assert_equal false, @tree._dirty?
    @tree.root.depth = 3
    assert_equal true, @tree.root._dirty?
    assert_equal true, @tree._dirty?
  end

  def test_array_with_sub_models
    assert_equal 1, @tree.array_of_roots.first.depth
    assert_equal false, @tree._dirty?
    @tree.array_of_roots.first.depth = 2
    assert_equal true, @tree.array_of_roots.first._dirty?
    assert_equal true, @tree._dirty?
    @tree._reset_dirty_tracker!
    assert_equal false, @tree.array_of_roots.first._dirty?
    assert_equal false, @tree._dirty?
  end

  def test_hash_with_value_sub_model
    assert_equal 1, @tree.hash_of_symbol_root[:one].depth
    assert_equal false, @tree._dirty?
    @tree.hash_of_symbol_root[:one].depth = 2
    assert_equal true, @tree.hash_of_symbol_root[:one]._dirty?
    assert_equal true, @tree._dirty?
    @tree._reset_dirty_tracker!
    assert_equal false, @tree.hash_of_symbol_root[:one]._dirty?
    assert_equal false, @tree._dirty?
  end
end
