require 'test_helper'

class HashCoercionTest < Minitest::Test
  class HashObject
    include Atrs
    attribute :hash,           Hash
    attribute :string_symbol,  Hash[String => Symbol]
    attribute :integer_float,  Hash[Integer => Float]
    attribute :time_set,       Hash[Time => Set]
    attribute :nil,            Hash
  end

  def test_coercion
    now = Time.now
    later = now + 1
    object = HashObject.new(
      hash: { any: 'thing'},
      string_symbol: { 1 => 'one', :two => 'two'},
      integer_float: { '1' => 1, 2.0 => '2.2'},
      time_set: { now.to_i => [1,1], later.to_s => Set.new([2,2])}
    )
    assert_equal 'thing', object.hash[:any]
    assert_equal :one, object.string_symbol['1']
    assert_equal :two, object.string_symbol['two']
    assert_equal 1.0, object.integer_float[1]
    assert_equal 2.2, object.integer_float[2]
    assert_equal Set.new([1]), object.time_set[Time.at(now.to_i)]
    assert_equal Set.new([2]), object.time_set[Time.at(later.to_i)]
    assert_equal Hash.new, object.nil
  end

  def test_error
    assert_raises Atrs::Coercions::UnsupportedError do
      HashObject.new(string_symbol: [1,2])
    end
    assert_raises Atrs::Coercions::UnsupportedError do
      HashObject.new(integer_float: Time.now)
    end
  end
end
