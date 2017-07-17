require 'test_helper'

class ImmutableTest < TestBase
  class Person
    include Wardrobe
    attribute :name, String
  end

  class ImmutableClass
    include Wardrobe
    plugin :immutable
    attribute :string, String
    attribute :hash, Hash
    attribute :array, Array
    attribute :array_of_people, Array[Person]
  end

  def setup
    @object = ImmutableClass.new(
      string: 'Clean',
      hash: { one: 'value' },
      array: [
        'one'
      ],
      array_of_people: [
        { name: 'Person 1' }
      ]
    )
  end

  def test_setter_no_method_error
    assert_raises(NoMethodError) do
      @object.string = 'Changed'
    end
  end

  def test_immutable_hash_raises_error
    assert_raises(RuntimeError) do
      @object.hash[:two] = 'another_value'
    end
  end

  def test_immutable_array_raises_error
    assert_raises(RuntimeError) do
      @object.array << 'two'
    end
  end

  def test_child_wardrobe_object_raises_error
    assert_raises(RuntimeError) do
      @object.array_of_people.first.name = 'Person 2'
    end
  end

  def test_instance_frozen
    assert @object.frozen?
  end

  def mutate_test
    @mutated_object = yield
    refute_equal @mutated_object.object_id, @object.object_id
  end

  def test_immutable_args_only_changes_given_pairs
    mutate_test do
      @object.mutate(string: 'Changed')
    end
    assert_equal @object.array, @mutated_object.array
  end

  def test_immutable_string_args
    mutate_test do
      @object.mutate(string: 'Changed')
    end
    assert_equal 'Clean', @object.string
    assert_equal 'Changed', @mutated_object.string
  end

  def test_immutable_string_block
    mutate_test do
      @object.mutate do |o|
        o.string = 'Changed'
      end
    end
    assert_equal 'Changed', @mutated_object.string
    assert_equal 'Clean', @object.string
  end

  def test_immutable_hash_args
    mutate_test do
      @object.mutate(hash: @object.hash.merge(added: 'key'))
    end
    assert_equal({ one: 'value', added: 'key' }, @mutated_object.hash)
    assert_equal({ one: 'value' }, @object.hash)
    assert_raises(RuntimeError) { @mutated_object.hash[:should] = 'fail' }
    assert_raises(RuntimeError) { @object.hash[:should] = 'fail' }
  end

  def test_immutable_hash_block
    mutate_test do
      @object.mutate do |o|
        o.hash[:added] = 'key'
      end
    end
    assert_equal({ one: 'value', added: 'key' }, @mutated_object.hash)
    assert_equal({ one: 'value' }, @object.hash)
    assert_raises(RuntimeError) { @mutated_object.hash[:should] = 'fail' }
    assert_raises(RuntimeError) { @object.hash[:should] = 'fail' }
  end

  def test_immutable_array_args
    mutate_test do
      @object.mutate(array: @object.array + ['added element'])
    end
    assert_equal(['one', 'added element'], @mutated_object.array)
    assert_equal(['one'], @object.array)
    assert_raises(RuntimeError) { @mutated_object.array << 'Should fail' }
    assert_raises(RuntimeError) { @object.array << 'Should fail' }
  end

  def test_immutable_array_block
    mutate_test do
      @object.mutate do |o|
        o.array << 'added element'
      end
    end
    assert_equal(['one', 'added element'], @mutated_object.array)
    assert_equal(['one'], @object.array)
    assert_raises(RuntimeError) { @mutated_object.array << 'Should fail' }
    assert_raises(RuntimeError) { @object.array << 'Should fail' }
  end

  def test_mutate_block
    new_object = @object.mutate do |o|
      o.string = 'In Mutate Block'
      o.array << 'Another Leave'
      o.hash[:added_key] = 'From mutate block'
      o.array_of_people.first.name = 'Changed child instance name'
      o.array_of_people << { name: 'Added friend in mutate block' }
    end
    assert @object.frozen?
    assert @object.array_of_people.frozen?
    assert_equal 2, new_object.array.count
    assert new_object.frozen?
    assert new_object.array_of_people.frozen?
    assert_equal 2, new_object.array_of_people.count
    assert new_object.array_of_people.all? { |person| person.class == Person }
    refute new_object.array_of_people.instance_variable_defined?(:@_mutating)
  end
end
