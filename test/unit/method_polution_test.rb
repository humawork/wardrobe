require 'test_helper'

class MethodPolutionTest < Minitest::Test

  ALLOWED_POLUTING_PLUGINS = { immutable: [:mutate] }

  class WardrobeClassWithoutPlugins
    include Wardrobe
  end

  class WardrobeClassWithCleanPlugins
    include Wardrobe
    plugin(*(Wardrobe.plugins.keys - ALLOWED_POLUTING_PLUGINS.keys))
  end

  class WardrobeClassWithAllowedPolutingPlugins
    include Wardrobe
    plugin(*(ALLOWED_POLUTING_PLUGINS.keys))
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
    assert_equal ALLOWED_POLUTING_PLUGINS.values.flatten, methods_class_with_polution_allowed_plugins.delete_if { |m| m.to_s[/^_/] }
  end
end
