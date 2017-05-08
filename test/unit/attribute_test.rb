require 'test_helper'


class AttributeTest < Minitest::Test
  class One
    include Wardrobe
    attribute :name, String
  end

  class Two < One
    plugin :optional_getter
  end

  class Three < Two
    attribute :name, String, getter: false
  end

  module Override
    def getters

    end
  end

  def test_attribute_parent
    assert_equal 'Test', One.new(name: 'Test').name
    assert_equal 'Test', Two.new(name: 'Test').name
    assert_raises(NoMethodError) {
      Three.new(name: 'Test').name
    }
  end

  def test_getter
    assert_instance_method_call_count(2, Wardrobe::Attribute, :build_getter_array) do
      klass = Class.new do
        include Wardrobe
        attribute :name, String
      end
      Class.new(klass) do
        include Wardrobe
        attribute :name, String
      end
    end
  end
end
