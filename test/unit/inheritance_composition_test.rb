# frozen_string_literal: true

require 'test_helper'

class InheritanceCompositionTest < Minitest::Test
  # Test a simple class with Wardrobe included
  class SimpleClass
    include Wardrobe
    attribute :name, String
  end

  def test_simple_class
    instance = SimpleClass.new(name: 'Test')
    assert_equal 'Test', instance.name
  end

  # Test a class inherits from SimpleClass

  class InheritedClass < SimpleClass
    plugin :default
    attribute :age, Integer, default: 18
  end

  def test_plugin_registered_on_inherited_class_only
    assert_nil SimpleClass.plugin_store[:default]
    assert InheritedClass.plugin_store[:default]
  end

  def test_inherited_class
    instance = InheritedClass.new(name: 'Test Inherited')
    assert_equal 'Test Inherited', instance.name
    assert_equal 18, instance.age
  end

  # Add tests for different modules
end
