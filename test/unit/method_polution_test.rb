require 'test_helper'

class MethodPolutionTest < TestBase

  ALLOWED_POLUTING_PLUGINS = { immutable: [:mutate], merge: [:merge, :deep_merge] }

  class WardrobeClassWithoutPlugins
    include Wardrobe
  end

  class WardrobeClassWithCleanPlugins
    include Wardrobe
    (Wardrobe.plugins.keys - ALLOWED_POLUTING_PLUGINS.keys).each do |plugin_name|
      plugin plugin_name
    end
  end

  class WardrobeClassWithAllowedPolutingPlugins
    include Wardrobe
    ALLOWED_POLUTING_PLUGINS.keys.each do |plugin_name|
      plugin plugin_name
    end
  end

  def methods_class_without_plugins
    WardrobeClassWithoutPlugins.new.methods - Object.methods
  end

  def methods_class_with_clean_plugins
    WardrobeClassWithCleanPlugins.new.methods - Object.methods
  end

  def methods_class_with_polution_allowed_plugins
    WardrobeClassWithAllowedPolutingPlugins.new.methods - Object.methods
  end

  def test_without_plugins
    assert_equal [], methods_class_without_plugins.delete_if { |m| m.to_s[/^_/] }
  end

  def test_with_plugins
    assert_equal [], methods_class_with_clean_plugins.delete_if { |m| m.to_s[/^_/] }
  end

  def test_allowed_methods
    assert_equal ALLOWED_POLUTING_PLUGINS.values.flatten.to_set, methods_class_with_polution_allowed_plugins.delete_if { |m| m.to_s[/^_/] }.to_set
  end
end
