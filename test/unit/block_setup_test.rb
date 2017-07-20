require 'test_helper'

class BlockModel
  include Wardrobe
  plugin :nil_if_empty
  plugin :nil_if_zero
  plugin :test_plugin
  plugin :alias_setters
  plugin :validation

  attributes nil_if_empty: true, nil_if_zero: true, preset: :one, validates: { method: :int?, arguments: 1 }, alias_setter: :nested_int_alias do
    attribute :name,    String, preset: :two, validates: { method: :str?, arguments: 1 }
    attribute :status,  Integer
    attribute :friends, Array
    nil_if_empty false do
      attribute :address, String
      nil_if_zero false do
        attribute :id, Integer
        attribute :uuid, Integer, nil_if_zero: true
        nil_if_zero true do
          attributes nil_if_zero: false do
            attribute :nested_int, Integer, alias_setter: :nested_int_alias_2
          end
        end
      end
    end
  end
end

class BlockSetupTest < TestBase
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
