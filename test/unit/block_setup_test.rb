require 'test_helper'

class BlockModel
  extend Attributable

  attributes nil_if_empty: true, nil_if_zero: true do
    attribute :name,    String
    attribute :status,  Integer
    attribute :friends, Array
    nil_if_empty false do
      attribute :address, String
      nil_if_zero false do
        attribute :id, Integer
        attribute :uuid, Integer, nil_if_zero: true
        nil_if_zero true do
          attributes nil_if_zero: false do
            attribute :nested_int, Integer
          end
        end
      end
    end
  end
end


class BlockSetupTest < Minitest::Test
  def test_one
    instance = BlockModel.new(name: '', status: 0, friends: [], address: '', id: 0, uuid: 0, nested_int: 0 )
    assert_nil instance.name
    assert_nil instance.status
    assert_nil instance.friends
    assert_equal '', instance.address
    assert_equal 0, instance.id
    assert_nil instance.uuid
    assert_equal 0, instance.nested_int
  end
end
