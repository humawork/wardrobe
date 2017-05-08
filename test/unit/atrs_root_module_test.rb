# frozen_string_literal: true

require 'test_helper'

class WardrobeRootModuleTest < Minitest::Test
  def test_wardrobe_module
    assert Wardrobe.config.is_a?(Wardrobe::RootConfig)
    assert Wardrobe.respond_to?(:create_class)
  end

  def test_wardrobe_method_generated_module
    mod = Module.new do
      extend Wardrobe::ModuleMethods
      include Wardrobe
    end
    assert mod.respond_to?(:create_class)
    assert mod.config.is_a?(Wardrobe::RootConfig)
  end
end
