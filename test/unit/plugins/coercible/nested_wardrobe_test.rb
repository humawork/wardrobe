require 'test_helper'

class NestedWardrobeTest < TestBase

  class One
    include Wardrobe
    attribute :name, String
  end

  class Two
    include Wardrobe
    attribute :user, One
  end

  class Three
    include Wardrobe
    attribute :group, Array[Two]
  end

  def test_coercion
    object = Three.new(
      group: [
        {
          user: {
            name: 'Foo'
          }
        },
        {
          user: {
            name: 'Bar'
          }
        }
      ]
    )

    assert_equal 'Foo', object.group.first.user.name
    assert_equal 'Bar', object.group.last.user.name
  end

  def test_nil_as_input_for_nested_wardrobe
    object = Three.new(
      group: nil
    )

    assert_equal [], object.group
  end

  def test_string_as_input_for_nested_wardrobe
    assert_raises(ArgumentError) do
      Two.new(
        user: 'Foo'
      )
    end
  end

  def test_string_as_input_for_nested_wardrobe_in_array
    assert_raises(Wardrobe::Refinements::Coercible::UnsupportedError) do
      Three.new(
        group: 'Foo'
      )
    end
  end
end
