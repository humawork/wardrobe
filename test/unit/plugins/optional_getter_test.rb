require 'test_helper'

class OptionalGetterTest < TestBase
  class Foo
    include Wardrobe
    plugin :optional_getter
    attribute :bar, String, getter: false
  end

  def test_optinal_getter
    assert_raises(NoMethodError) do
      Foo.new(bar: 'value').bar
    end
  end
end
