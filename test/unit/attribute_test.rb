require 'test_helper'


class AttributeTest < Minitest::Test
  class One
    include Atrs
    attribute :name, String
  end

  class Two < One
    plugin :optional_getter
  end

  class Three < Two
    attribute :name, String, getter: false
  end

  def test_attribute_parent
    assert_equal 'Test', One.new(name: 'Test').name
    assert_equal 'Test', Two.new(name: 'Test').name
    assert_raises(NoMethodError) {
      Three.new(name: 'Test').name
    }
  end
end
