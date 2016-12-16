require 'test_helper'

class NilIfEmptyTest < Minitest::Test
  class Tree
    extend Attributable
    attribute :name,     String, nil_if_empty: true
    attribute :branches, Hash,   nil_if_empty: true
    attribute :leaves,   Array,  nil_if_empty: true
  end

  class TreeFalse
    extend Attributable
    attribute :name,     String, nil_if_empty: false
    attribute :branches, Hash,   nil_if_empty: false
    attribute :leaves,   Array,  nil_if_empty: false
  end

  def setup
    @tree = Tree.new(name: '', branches: {}, leaves: [])
    @tree_false = TreeFalse.new(name: '', branches: {}, leaves: [])
  end

  def test_string
    assert_equal nil, @tree.name
    assert_equal '', @tree_false.name
  end

  def test_hash
    assert_equal nil, @tree.branches
    assert_equal Hash.new, @tree_false.branches
  end

  def test_array
    assert_equal nil, @tree.leaves
    assert_equal [], @tree_false.leaves
  end
end
