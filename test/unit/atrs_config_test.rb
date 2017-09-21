# frozen_string_literal: true

require 'test_helper'

class WardrobeConfigTest < TestBase
  CUSTOM_ATRS_MODULE = Wardrobe()
  CUSTOM_ATRS_MODULE.configure do |config|
    config.register_default_plugin :default
  end

  class Person
    include CUSTOM_ATRS_MODULE
    attribute :name, String, default: 'Example Person'
  end

  def test_plugin_registered_in_module
    assert CUSTOM_ATRS_MODULE.config.default_plugins.include?(:default)
  end

  def test_plugin_added_to_class
    assert Person.plugin_store[:default]
    assert Person.option_store[:default]
  end

  def test_correct_plugin_and_option_count
    assert_equal 3, Person.option_store.store.count
    assert_equal 2, Person.plugin_store.store.count
  end

  def test_one
    assert_equal 'Example Person', Person.new.name
  end
end
