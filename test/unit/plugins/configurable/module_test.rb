require 'test_helper'

class ConfigurableModuleTest < TestBase
  class TestConfig
    include Wardrobe
    plugin :immutable
    attribute :title, String
    attribute :proc_test, Proc
  end

  module ModuleWithConfigurable
    include Wardrobe
    plugin :configurable
    configurable :config, :configure, TestConfig
  end

  class Person
    include ModuleWithConfigurable
    configurable :another, :configure_another, TestConfig
  end

  def test_configurable_in_plugin_store
    assert ModuleWithConfigurable.plugin_store.store[:configurable]
    assert Person.plugin_store.store[:configurable]
  end

  def test_configurable_store_on_module_and_class
    assert ModuleWithConfigurable.respond_to?(:configurable_store)
    assert Person.respond_to?(:configurable_store)
  end

  def test_configure_on_module_and_class
    assert ModuleWithConfigurable.respond_to?(:configure)
    assert Person.respond_to?(:configure)
  end

  def test_config_on_module_and_class
    assert ModuleWithConfigurable.respond_to?(:config)
    assert Person.respond_to?(:config)
  end

  def test_antother_config
    assert Person.respond_to?(:another)
    refute ModuleWithConfigurable.respond_to?(:another)
    assert Person.respond_to?(:configure_another)
    refute ModuleWithConfigurable.respond_to?(:configure_another)
    assert Person.configurable_store.store[:another]
    refute ModuleWithConfigurable.configurable_store.store[:another]
  end
end
