# frozen_string_literal: true

require 'test_helper'

class AtrsRootModuleTest < Minitest::Test
  def test_atrs_module
    assert Atrs.config.is_a?(Atrs::RootConfig)
    assert Atrs.respond_to?(:create_class)
  end

  def test_atrs_method_generated_module
    mod = Module.new do
      extend Atrs::ModuleMethods
      include Atrs
    end
    assert mod.respond_to?(:create_class)
    assert mod.config.is_a?(Atrs::RootConfig)
  end
end
