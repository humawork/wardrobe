require 'test_helper'

class SetCoercionTest < Minitest::Test
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

  def test_coercion
    object = SetObject.new(
      set: Set.new([1,1,2,2]),
      array: [3,3,4,4],
      nil: nil,
      set_with_subclass: Set.new([{name: 'Test'}]),
      array_with_subclass: [{name: 'Test'}]
    )
    assert_equal Set.new([1,2]), object.set
    assert_equal Set.new([3,4]), object.array
    assert_nil object.nil
    assert Person === object.set_with_subclass.first
    assert Person === object.array_with_subclass.first
  end

  def test_error
    assert_raises Wardrobe::Plugins::Coercible::Refinements::UnsupportedError do
      SetObject.new(set: Time.now)
    end
    assert_raises Wardrobe::Plugins::Coercible::Refinements::UnsupportedError do
      SetObject.new(array: 'string')
    end
  end
end
