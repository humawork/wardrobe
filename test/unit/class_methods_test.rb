require 'test_helper'

class WithFourAttributes
  extend Atrs
  attribute :first_name,   String
  attribute :last_name,    String
  attribute :email,        String
  attribute :phone_number, String
end

class WithOneAttributeRemoved < WithFourAttributes
  remove_attribute :last_name
  remove_attributes :email, :phone_number
end

module Essentials
  extend Atrs
  attribute :id, String
end

module SomeExtraAttributes
  extend Atrs
  attribute :hair_style, String
end

module ComposedModule
  extend Essentials
  extend SomeExtraAttributes
end

class KlassWithIncludedModule < WithFourAttributes
  extend SomeExtraAttributes
end

class CoerceToStringTest
  extend Atrs
  attribute :number, Integer
end

class WithExtendedModule
  extend Essentials
  attribute :another, String
end


class TestFirst < Minitest::Test
  def test_with_two_attributes
    klass = WithFourAttributes
    instance = klass.new(first_name: 'Foo', last_name: 'Bar')

    assert klass.singleton_class.included_modules.include?(Atrs::ClassMethods)
    assert klass.attribute_set.first_name
    assert klass.attribute_set[:last_name]
    assert_equal 4, klass.attribute_set.length
    assert_equal 'Foo', instance.first_name
    assert_equal 'Bar', instance.last_name
  end

  def test_with_one_attribute
    klass = WithOneAttributeRemoved
    assert_equal 1, klass.attribute_set.length
  end

  def test_class_with_added_module
    klass = KlassWithIncludedModule
    assert_equal 5, klass.attribute_set.length
  end

  def test_class_with_extended_module
    klass = WithExtendedModule
    assert_equal 2, klass.attribute_set.length
  end

  def test_coercien
    instance = CoerceToStringTest.new(number: '1')
    assert_equal 1, instance.number
  end

  def test_adding_attribute_to_instance
    klass = WithFourAttributes
    instance = klass.new(first_name: 'Test')
    instance2 = klass.new(first_name: 'Test2')
    instance._add_attribute(:dynamic, Integer)
    instance2._add_attribute(:dynamic, String)
    assert_equal 4, klass.attribute_set.length
    assert_equal 5, instance._attribute_set.length
    assert_equal 5, instance2._attribute_set.length
    assert_equal Integer, instance._attribute_set.dynamic.klass
    assert_equal String, instance2._attribute_set.dynamic.klass
    assert_nil klass.attribute_set[:dynamic]
  end
end
