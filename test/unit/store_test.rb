require 'test_helper'

class StoreTest < TestBase

  class TestStore < Wardrobe::Store

  end

  def test_super_in_method_missing
    store = TestStore.new
    assert_raises(NoMethodError) do
      store.some_missing_method
    end
  end
end
