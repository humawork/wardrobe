require 'test_helper'

module DefaultMixin
  extend Atrs
  plugin :default
  attribute :name,     String, default: 'missing name'
  attribute :address,  String, default: :address_default
  attribute :zip_code, String, default: -> { '0' + '1' }

  module InstanceMethods
    def address_default
      'missing address'
    end
  end
end

class House
  extend DefaultMixin
  attribute :floors,     Integer, default: 2
  attribute :bedrooms,   Integer, default: :bedrooms_default
  attribute :bathrooms,  Integer, default: ->() { 1 + 3 }
  attribute :no_default, String

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
    assert_equal 'missing name', @house.name
  end

  def test_default_symbol
    assert_equal 10, @house.bedrooms
    assert_equal 'missing address', @house.address
  end

  def test_default_proc
    assert_equal 4, @house.bathrooms
  end

  def test_no_default
    assert_equal nil, @house.no_default
  end
end
