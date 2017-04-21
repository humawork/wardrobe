require 'test_helper'

class ArrayCoercionTest < Minitest::Test
  class Person
    include Atrs
    attribute :name, String
  end

  class ArrayObject
    include Atrs
    attribute :set,                       Array
    attribute :array,                     Array
    attribute :array_integer,             Array[Integer]
    attribute :array_string,              Array[String]
    attribute :array_hash,                Array[Hash]
    attribute :array_hash_integer_symbol, Array[Hash[Integer => Symbol]]
    attribute :array_atrs_objects,        Array[Person]
    attribute :nil,                       Array
  end

  def setup
    @object = ArrayObject.new(
      set: Set.new([1,2]),
      array: [3,4],
      array_integer: ['1', '2.0', 3, 4.3],
      array_string: [1, 2.0, '3'],
      array_hash: [{one: '1'}, ['two', 2.4]],
      array_hash_integer_symbol: [{1.0 => 'one'}, ['2', 'two']],
      array_atrs_objects: [{name: 'Test Person'}],
      nil: nil
    )
  end

  def test_coercion
    assert_equal [1,2], @object.set
    assert_equal [3,4], @object.array
    assert_equal [1,2,3,4], @object.array_integer
    assert_equal ['1','2.0','3'], @object.array_string
    assert_equal [{one: '1'}, {'two' => 2.4}], @object.array_hash
    assert_equal [{1 => :one}, {2 => :two}], @object.array_hash_integer_symbol
    assert Person === @object.array_atrs_objects[0]
    assert_equal [], @object.nil
  end

  def test_array_with_multiple_items
    klass = Class.new do
      include Atrs
      attribute :array, Array[Integer, Hash]
    end
    assert_raises(StandardError) do
      klass.new(array: ['1'])
    end
  end

  def test_coercion_when_modifying_array
    @object.array_atrs_objects << { name: '1' }
    assert Person === @object.array_atrs_objects[1]
    @object.array_atrs_objects.push({ name: '2' })
    assert Person === @object.array_atrs_objects[2]
    @object.array_atrs_objects.unshift({ name: '3' })
    assert Person === @object.array_atrs_objects[3]
    assert_equal 4, @object.array_atrs_objects.count
    assert @object.array_atrs_objects.all? { |item| Person === item }
  end
end
