# frozen_string_literal: true

require 'test_helper'

class AtrsConfigTest < Minitest::Test
  CUSTOM_ATRS_MODULE = Atrs()
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
    assert Person.atrs_config.plugin_store[:default]
    assert Person.atrs_config.option_store[:default]
  end

  def test_correct_plugin_and_option_count
    assert_equal 1, Person.atrs_config.option_store.store.count
    assert_equal 1, Person.atrs_config.plugin_store.store.count
  end

  def test_one
    assert_equal 'Example Person', Person.new.name
  end
end
