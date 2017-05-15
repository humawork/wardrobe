require 'test_helper'
class DisableCoercionTest < TestBase
  class NoCoercion
    include Wardrobe(coerce: false)
    attribute :name, String
  end

  def setup
    @instance = NoCoercion.new(name: :test)
  end

  def test_model
    assert_equal false, NoCoercion.root_config.coerce
  end

  def test_no_coercion
    assert_equal :test, @instance.name
  end
end
