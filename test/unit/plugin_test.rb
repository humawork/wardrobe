require 'test_helper'

class PluginTest < TestBase
  def test_no_plugin_error
    assert_raises(Wardrobe::NoPluginRegisteredError) do
      Class.new do
        include Wardrobe
        plugin :missing
      end
    end
  end
end
