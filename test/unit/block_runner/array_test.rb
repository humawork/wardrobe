require 'test_helper'

class BlockRunnerArray
  include Wardrobe
  plugin :test_plugin

  attributes preset: :one do
    attribute :name, String
    preset :two do
      attribute :address, String
      preset :three do
        attribute :uuid, String
        attribute :id,   Integer, preset: [:four, :five]
      end
    end
  end
end


class BlockRunnerArrayTest < TestBase
  def test_one
    instance = BlockRunnerArray.new(name: 'Name',  address: 'Address', uuid: 1, id: 123 )
    set = instance._attribute_store
    assert_equal [:one], set.name.options[:preset].to_a
    assert_equal [:one, :two], set.address.options[:preset].to_a
    assert_equal [:one, :two, :three], set.uuid.options[:preset].to_a
    assert_equal [:one, :two, :three, :four, :five], set.id.options[:preset].to_a
  end
end
