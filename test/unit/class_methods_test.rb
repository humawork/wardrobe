require 'test_helper'

class WithFourAttributes
  include Wardrobe
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
  include Wardrobe
  attribute :id, String
end

module SomeExtraAttributes
  include Wardrobe
  attribute :hair_style, String
end

module ComposedModule
  include Essentials
  include SomeExtraAttributes
end

class KlassWithIncludedModule < WithFourAttributes
  include SomeExtraAttributes
end

class CoerceToStringTest
  include Wardrobe
  attribute :number, Integer
end

class WithExtendedModule
  include Essentials
  attribute :another, String
end


class ClassMethodsTest < TestBase
  def test_with_two_attributes
    klass = WithFourAttributes
    instance = klass.new(first_name: 'Foo', last_name: 'Bar')

    assert klass.singleton_class.included_modules.include?(Wardrobe::ClassMethods)
    assert klass.attribute_store.first_name
    assert klass.attribute_store[:last_name]
    assert_equal 4, klass.attribute_store.count
    assert_equal 'Foo', instance.first_name
    assert_equal 'Bar', instance.last_name
  end

  def test_with_one_attribute
    klass = WithOneAttributeRemoved
    assert_equal 1, klass.attribute_store.count
  end

  def test_class_with_added_module
    klass = KlassWithIncludedModule
    assert_equal 5, klass.attribute_store.count
  end

  def test_class_with_includeed_module
    klass = WithExtendedModule
    assert_equal 2, klass.attribute_store.count
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
    assert_equal 4, klass.attribute_store.count
    assert_equal 5, instance._attribute_store.count
    assert_equal 5, instance2._attribute_store.count
    assert_equal Integer, instance._attribute_store.dynamic.klass
    assert_equal String, instance2._attribute_store.dynamic.klass
    assert_nil klass.attribute_store[:dynamic]
  end
end
