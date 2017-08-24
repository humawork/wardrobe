require 'test_helper'

class OptionSetTest < TestBase

  module TestPlugin
    extend Wardrobe::Plugin
    option :a_set, Set
  end
  Wardrobe.register_plugin(:set_test_plugin, TestPlugin)

  class Foo
    include Wardrobe
    plugin :set_test_plugin
    attribute :bar_1, String, a_set: :one
    attribute :bar_2, String, a_set: [:two, :three]
  end

  def test_one
    assert_kind_of Set, Foo.attribute_store.bar_1.options[:a_set]
    assert_kind_of Set, Foo.attribute_store.bar_2.options[:a_set]
  end
end
