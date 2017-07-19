require 'test_helper'

class SetCoercionTest < TestBase
  class Person
    include Wardrobe
    attribute :name, String
  end

  class SetObject
    include Wardrobe
    attribute :set,   Set
    attribute :array, Set
    attribute :nil,   Set
    attribute :set_with_subclass, Set[Person]
    attribute :array_with_subclass, Set[Person]
  end

  class ImmutableSetObject
    include Wardrobe
    plugin :immutable
    attribute :set_with_strings, Set[String]
  end

  def test_coercion
    object = SetObject.new(
      set: Set.new([1, 1, 2, 2]),
      array: [3, 3, 4, 4],
      nil: nil,
      set_with_subclass: Set.new([{ name: 'Test' }]),
      array_with_subclass: [{ name: 'Test' }]
    )
    assert_equal Set.new([1, 2]), object.set
    assert_equal Set.new([3, 4]), object.array
    assert_equal Set.new, object.nil
    assert object.set_with_subclass.first.is_a?(Person)
    assert object.array_with_subclass.first.is_a?(Person)
  end

  def test_set_instance_coercion
    object = SetObject.new(set_with_subclass: nil)
    assert_equal Set.new, object.set_with_subclass
  end

  def test_modifying_set_with_add
    object = SetObject.new
    object.set_with_subclass.add(name: 'Added with add')
    assert object.set_with_subclass.to_a.first.is_a?(Person)
    assert_equal 'Added with add', object.set_with_subclass.to_a.first.name
  end

  def test_modifying_set_with_add_alias
    object = SetObject.new
    object.set_with_subclass << { name: 'Added with <<' }
    assert object.set_with_subclass.to_a.first.is_a?(Person)
    assert_equal 'Added with <<', object.set_with_subclass.to_a.first.name
  end

  def test_modifying_set_with_merge
    object = SetObject.new
    object.set_with_subclass.merge([{ name: 'Added with merge' }])
    assert object.set_with_subclass.to_a.first.is_a?(Person)
    assert_equal 'Added with merge', object.set_with_subclass.to_a.first.name
  end

  def test_error
    assert_raises Wardrobe::Plugins::Coercible::Refinements::UnsupportedError do
      SetObject.new(set_with_subclass: :sym)
    end
    assert_raises Wardrobe::Plugins::Coercible::Refinements::UnsupportedError do
      SetObject.new(set: Time.now)
    end
    assert_raises Wardrobe::Plugins::Coercible::Refinements::UnsupportedError do
      SetObject.new(array: 'string')
    end
  end

  def test_immutable
    object = ImmutableSetObject.new(set_with_strings: [:foo])
    assert_raises(RuntimeError) do
      object.set_with_strings.add(:bar)
    end
    new_object = object.mutate do |obj|
      obj.set_with_strings.add(:bar)
    end
    assert_equal Set.new(['foo', 'bar']), new_object.set_with_strings
  end
end
