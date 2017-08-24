require 'test_helper'

class OptionTest < TestBase

  def test_invalid_option
    assert_raises(Wardrobe::UnavailableOptionError) do
      Class.new do
        include Wardrobe
        attribute :name, String, should_fail: :option
      end
    end
    Class.new do
      include Wardrobe
      attribute :name, String, coerce: false
    end
  end
end
