require 'test_helper'

module ValidateMixin
  include Atrs
  plugin :validation
  attribute :name, String, validates: { in: %w(Two Words) }
end

class KlassOne
  include ValidateMixin
end

class KlassTwo
  include ValidateMixin
  attribute :name, String, validates: { length: 10..100 }
  attribute :name1, String, validates: { length: 10..100 }
end

class KlassThree < KlassTwo
  attributes do
    validates match: /$[A-Z]+^/ do
      attribute :name, String
    end
  end
end

class InheritanceTest < Minitest::Test
  def test_inheritance
    instance = KlassOne.new(name: 'Lorem')
    assert_equal [:in], instance._attribute_store.name.validates.keys
    instance = KlassTwo.new(name: 'Lorem')
    assert_equal [:in, :length], instance._attribute_store.name.validates.keys
    instance = KlassThree.new(name: 'Lorem')
    assert_equal [:in, :length, :match], instance._attribute_store.name.validates.keys
  end
end
