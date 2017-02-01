require 'test_helper'

class Address
  extend Atrs
  plugin :presenter
  attribute :zip_code, String

end

class User
  extend Atrs
  plugin :presenter
  attribute :name,     String
  attribute :email,    String
  attribute :address,  Address
  attribute :password, String
  attribute :status,   Symbol
  attribute :friends,  Array[Integer]
end

class PresenterTest < Minitest::Test
  def setup
    @user = User.new(
      name: 'Test Person',
      email: 'user@example.com',
      address: { zip_code: '1234'},
      status: :open,
      friends: ['1',2]
    )
  end

  def test_one
    result = @user._present
    assert_equal 'Test Person', result[:name]
    assert_equal 'user@example.com', result[:email]
    assert_equal '1234', result[:address][:zip_code]
    assert_equal :open, result[:status]
    assert_equal [1,2], result[:friends]
  end
end
