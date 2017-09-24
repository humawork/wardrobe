require 'test_helper'

class OptionTest < TestBase
  def test_invalid_option
    no_log do
      assert_raises(Wardrobe::UnavailableOptionError) do
        Class.new do
          include Wardrobe
          attribute :name, String, should_fail: :option
        end
      end
    end
    Class.new do
      include Wardrobe
      attribute :name, String, coerce: false
    end
  end




  def test_merge_of_boolean
    klass = Class.new do
      include Wardrobe
      plugin :nil_if_empty
      attribute :foo, Array, nil_if_empty: true
    end

    child_klass = Class.new(klass) do
      attribute :foo, Hash
    end

    assert_equal true, child_klass.attribute_store.foo.options[:nil_if_empty]
  end
end
