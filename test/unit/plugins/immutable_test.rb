require 'test_helper'

# class DirtyRoot
#   include Atrs
#   plugin :dirty_tracker
#   attribute :depth, Integer
# end
#
# class DirtyTree
#   include Atrs
#   plugin :dirty_tracker
#   attribute :name,     String
#   attribute :branches, Hash
#   attribute :leaves,   Array
#   attribute :colors,   Set
#   attribute :root,     DirtyRoot
#   # TODO: Test sub atrs class
# end

class ImmutableTest < Minitest::Test

  class Friend
    include Atrs
    attribute :name, String
  end

  class ImmutableTree
    include Atrs
    plugin :immutable
    attribute :name, String
    attribute :branches, Hash
    attribute :leaves, Array
    attribute :friends, Array[Friend]
  end


  def setup
    @tree = ImmutableTree.new(name: 'CleanTree', branches: {one: 'value'}, leaves: ['one'], friends: [{ name: 'Oak'}],)
  end

  # def test_setter_order
  #   binding.pry
  # end

  def test_setter_no_method_error
    assert_raises(NoMethodError) {
      @tree.name = 'ChangedTree'
    }
  end

  def test_immutable_hash_raises_error
    assert_raises(RuntimeError) {
      @tree.branches[:two] = 'another_value'
    }
  end

  def test_immutable_array_raises_error
    assert_raises(RuntimeError) {
      @tree.leaves << 'Another Leave'
    }
  end

  def test_child_atrs_object_raises_error
    assert_raises(RuntimeError) {
      @tree.friends.first.name = 'Birch'
    }
  end

  def test_instance_frozen
    assert @tree.frozen?
  end

  def test_immutable_string
    old_object_id = @tree.object_id
    new_tree = @tree.set(name: 'ChangedTree')
    assert_equal 'CleanTree', @tree.name
    assert_equal 'ChangedTree', new_tree.name
    refute_equal new_tree.object_id, @tree.object_id
  end

  def test_mutate_block
    new_tree = @tree.set do |tree|
      tree.name = 'In Mutate Block'
      tree.leaves << 'Another Leave'
    end
    assert @tree.frozen?
    assert @tree.friends.frozen?
    assert new_tree.frozen?
    assert new_tree.friends.frozen?
  end
end
