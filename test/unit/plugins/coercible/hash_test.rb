require 'test_helper'

class HashCoercionTest < TestBase
  class Person
    include Wardrobe
    attribute :name, String
  end

  class HashObject
    include Wardrobe
    attribute :hash,           Hash
    attribute :string_symbol,  Hash[String => Symbol]
    attribute :integer_float,  Hash[Integer => Float]
    attribute :time_set,       Hash[Time => Set]
    attribute :person_int,     Hash[Person => Integer]
    attribute :string_person,  Hash[String => Person]
    attribute :nil,            Hash
  end

  class ImmutableHashObject
    include Wardrobe
    plugin :immutable
    attribute :string_symbol,  Hash[String => Symbol]
  end

  def setup
    @now = Time.now
    @later = @now + 1
    @object = HashObject.new(
      hash: { any: 'thing'},
      string_symbol: { 1 => 'one', :two => 'two'},
      integer_float: { '1' => 1, 2.0 => '2.2'},
      time_set: { @now.to_i => [1,1], @later.to_s => Set.new([2,2])},
      person_int: { { name: 'Test' } => '1' },
      string_person: { 1 => { name: 'Test' } }
    )
  end

  def test_coercion
    assert_equal 'thing', @object.hash[:any]
    assert_equal :one, @object.string_symbol['1']
    assert_equal :two, @object.string_symbol['two']
    assert_equal 1.0, @object.integer_float[1]
    assert_equal 2.2, @object.integer_float[2]
    assert_equal Set.new([1]), @object.time_set[Time.at(@now.to_i)]
    assert_equal Set.new([2]), @object.time_set[Time.at(@later.to_i)]
    assert_equal '1', @object.string_person.keys.first
    assert_equal 1, @object.person_int.values.first
    assert Person === @object.string_person.values.first
    assert Person === @object.person_int.keys.first
    assert_equal Hash.new, @object.nil
  end

  def test_modifying_hash
    @object.string_symbol[3] = 'three'
    assert_nil @object.string_symbol[3]
    assert_equal :three, @object.string_symbol['3']

    @object.string_symbol.merge!({4 => 'four', 5 => 'five'})
    assert_nil @object.string_symbol[4]
    assert_nil @object.string_symbol[5]
    assert_equal :four, @object.string_symbol['4']
    assert_equal :five, @object.string_symbol['5']

    @object.string_symbol.store(6, 'six')
    assert_nil @object.string_symbol[6]
    assert_equal :six, @object.string_symbol['6']
  end

  def test_with_empty_hash
    object = HashObject.new
    object.integer_float['1'] = '2'
    object.integer_float[1].class == Float
  end

  def test_error
    assert_raises Wardrobe::Plugins::Coercible::Refinements::UnsupportedError do
      HashObject.new(string_symbol: [1,2])
    end
    assert_raises Wardrobe::Plugins::Coercible::Refinements::UnsupportedError do
      HashObject.new(integer_float: Time.now)
    end
  end

  def test_immutable
    object = ImmutableHashObject.new(string_symbol: { foo: 'bar' })
    assert_raises(RuntimeError) do
      object.string_symbol[:foo2] = 'bar'
    end
    new_object = object.mutate do |obj|
      obj.string_symbol[:foo2] = 'bar2'
    end
    assert_equal :bar2, new_object.string_symbol['foo2']
  end
end
