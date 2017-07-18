require 'test_helper'

class AllPluginsTest < TestBase

  class PluginsWithMiddleware
    include Wardrobe
    plugin :default
    plugin :dirty_tracker
    plugin :optional_getter
    plugin :optional_setter
    plugin :nil_if_empty
    plugin :nil_if_zero

    attribute :foo, String, nil_if_zero: true, nil_if_empty: true, default: 5
  end

  def test_one
    instance = PluginsWithMiddleware.new(foo: '')
    # order = PluginsWithMiddleware.attribute_store.foo.setters.map(&:name)
    assert_equal 5, instance.foo
  end
end
