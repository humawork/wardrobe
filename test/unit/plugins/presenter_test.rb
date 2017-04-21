require 'test_helper'

class Address
  include Atrs
  plugin :presenter
  attribute :zip_code, String
  attribute :street,   String

end

class User
  include Atrs
  plugin :presenter
  attribute :name,     String
  attribute :email,    String
  attribute :address,  Address
  attribute :password, String
  attribute :status,   Symbol
  attribute :data,     Hash
  attribute :friends,  Array[Integer]
end

class PresenterTest < Minitest::Test
  def setup
    @user = User.new(
      name: 'Test Person',
      email: 'user@example.com',
      address: { zip_code: '1234', street: 'No Where Street'},
      status: :open,
      friends: ['1',2],
      data: {
        a: :b
      }
    )
  end

  def test_types
    result = @user._present
    assert_equal 'Test Person', result[:name]
    assert_equal 'user@example.com', result[:email]
    assert_equal '1234', result[:address][:zip_code]
    assert_equal :open, result[:status]
    assert_equal [1,2], result[:friends]
    assert_equal({a: :b}, result[:data])
  end

  def test_selection
    result = @user._present(atrs: { name: nil, address: { street: nil }})
    assert_equal 'Test Person', result[:name]
    assert_equal 'No Where Street', result[:address][:street]
    assert_nil result[:address][:zip_code]
    assert_nil result[:address][:status]
  end
end
