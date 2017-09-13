# frozen_string_literal: true

require 'test_helper'

class InitTest < TestBase

  class Bar
    include Wardrobe
    attribute :one, String
  end

  class Foo
    include Wardrobe
    plugin :flex_initializer
    attribute :one, String
    attribute :two, String
    attribute :child, Bar
  end

  def test_symbolized_hash
    data = { one: 'One', two: 'Two' }
    instance = Foo.new(data)
    assert_equal 'One', instance.one
    assert_equal 'Two', instance.two
  end

  def test_symbolized_hash_with_double_splat
    data = { one: 'One', two: 'Two' }
    instance = Foo.new(**data)
    assert_equal 'One', instance.one
    assert_equal 'Two', instance.two
  end

  def test_string_hash
    data = { 'one' => 'One', 'two' => 'Two', 'child' => { 'one' => 'Child One' } }
    instance = Foo.new(data)
    assert_equal 'One', instance.one
    assert_equal 'Two', instance.two
    assert_equal 'Child One', instance.child.one
  end

  def test_string_hash_with_double_splat
    assert_raises(TypeError) do
      data = { 'one' => 'One', 'two' => 'Two' }
      instance = Foo.new(**data)
    end
  end

  def test_combined_string_hash_and_key_args
    instance = Foo.new({ 'one' => 'One'}, two: 'Two')
    assert_equal 'One', instance.one
    assert_equal 'Two', instance.two
  end

  def test_init_with_string
    assert_raises do
      Foo.new('a string')
    end
  end
end
