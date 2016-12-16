require 'test_helper'

class House
  extend Attributable
  attribute :floors,    Integer, default: 2
  attribute :bedrooms,  Integer, default: :bedrooms_default
  attribute :bathrooms, Integer, default: ->() { 1 + 3 }

  def bedrooms_default
    10
  end
end


class DefaultValueTest < Minitest::Test

  def setup
    @house = House.new
  end

  def test_default_literal
    assert_equal 2, @house.floors
  end

  def test_default_symbol
    assert_equal 10, @house.bedrooms
  end

  def test_default_proc
    assert_equal 4, @house.bathrooms
  end
end
