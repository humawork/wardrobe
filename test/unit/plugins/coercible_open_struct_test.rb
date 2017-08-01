require 'test_helper'

class CoercibleOpenStructTest < TestBase
  class Person
    include Wardrobe
    attribute :name, String
  end

  class Foo
    include Wardrobe
    plugin :coercible_open_struct
    attribute :simple, OpenStruct
    attribute :open_struct, OpenStruct
    attribute :hash, OpenStruct
    attribute :integer, OpenStruct(Integer)
    attribute :string, OpenStruct(String)
    attribute :person, OpenStruct(Person)
  end

  class ImmutableFoo
    include Wardrobe
    plugin :immutable
    plugin :coercible_open_struct
    attribute :integer, OpenStruct(Integer)
  end

  def test_coercion
    instance = Foo.new(
      hash: {},
      open_struct: OpenStruct.new,
      integer: { one: '1'},
      string: nil,
      person: { one: {
        name: 'Test'
      }}
    )
    assert_equal 1, instance.integer.one
    instance.integer.two = '2'
    assert_equal 2, instance.integer.two
    instance.integer.two = '2.1'
    assert_equal 2, instance.integer.two
    instance.integer[:three] = '3'
    assert_equal 3, instance.integer.three
    instance.integer.three = '3.5'
    assert_equal 3, instance.integer.three
  end

  def test_immutable
    instance = ImmutableFoo.new
    assert_raises(RuntimeError) do
      instance.integer.new_val = 'Should not work'
    end
    mutated = instance.mutate do |inst|
      inst.integer.new_val = '1'
    end
    assert mutated.integer.frozen?
    assert_equal 1, mutated.integer.new_val
  end

  def test_error
    assert_raises Wardrobe::Plugins::Coercible::Refinements::UnsupportedError do
      Foo.new(hash: Time.now)
    end
  end

  def test_klass_error
    assert_raises Wardrobe::Plugins::Coercible::Refinements::UnsupportedError do
      klass = Class.new do
        include Wardrobe
        plugin :coercible_open_struct
        attribute :foo, OpenStruct(Integer)
      end
      klass.new(foo: Time.now)
    end
  end
end
