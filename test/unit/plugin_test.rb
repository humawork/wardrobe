# frozen_string_literal: true

require 'test_helper'


module TestPresenter
  extend Wardrobe::Plugin
  plugin :presenter
end
Wardrobe.register_plugin(:test_presenter, TestPresenter)



class PluginTest < TestBase
  def test_no_plugin_error
    assert_raises(Wardrobe::NoPluginRegisteredError) do
      Class.new do
        include Wardrobe
        plugin :missing
      end
    end
  end

  def test_plugin_dependent_on_another_plugin
    klass = Class.new do
      include Wardrobe
      plugin :test_presenter
    end
    assert klass.plugin_store.store.keys.include?(:presenter)
    assert klass.plugin_store.store.keys.include?(:test_presenter)
  end
end
