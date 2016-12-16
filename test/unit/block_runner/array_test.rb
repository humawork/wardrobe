require 'test_helper'

class BlockRunnerArray
  extend Attributable

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


class BlockRunnerArrayTest < Minitest::Test
  def test_one
    instance = BlockRunnerArray.new(name: 'Name',  address: 'Address', uuid: 1, id: 123 )
    set = instance._attribute_set
    assert_equal [:one], set.name.preset
    assert_equal [:one, :two], set.address.preset
    assert_equal [:one, :two, :three], set.uuid.preset
    assert_equal [:one, :two, :three, :four, :five], set.id.preset
  end
end
