require 'test_helper'

class StoresTest < TestBase

  class TestStore < Wardrobe::Store

  end

  def test_add_store
    klass = Class.new do
      include Wardrobe
    end

    wardrobe_store = klass.wardrobe_stores.add_store(:test, TestStore)

    assert_equal TestStore, wardrobe_store.stores[:test]
  end
end
