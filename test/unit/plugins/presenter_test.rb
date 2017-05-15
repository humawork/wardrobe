require 'test_helper'
class PresenterTest < TestBase
  class Address
    include Wardrobe
    plugin :presenter
    attribute :zip_code, String
    attribute :street,   String
  end

  class User
    include Wardrobe
    plugin :presenter, time_formatter: proc { |input| input.utc.iso8601 }
    attribute :name,     String
    attribute :email,    String
    attribute :address,  Address
    attribute :password, String
    attribute :status,   Symbol
    attribute :data,     Hash
    attribute :created,  Time
    attribute :friends,  Array[User]
  end

  def setup
    @time = Time.now - 60
    @user = User.new(
      name: 'Test Person',
      email: 'user@example.com',
      address: { zip_code: '1234', street: 'No Where Street'},
      status: :open,
      friends: [{ name: 'Friend One' }],
      created: @time.to_s,
      data: {
        a: :b
      }
    )
  end

  def test_types
    result = @user._present
    assert_equal 'Friend One', result[:friends].first[:name]
    assert_equal 'Test Person', result[:name]
    assert_equal 'user@example.com', result[:email]
    assert_equal '1234', result[:address][:zip_code]
    assert_equal :open, result[:status]
    assert_equal @time.utc.iso8601, result[:created]
    assert_equal({a: :b}, result[:data])
  end

  def test_selection
    result = @user._present(attributes: { name: nil, address: { street: nil }})
    assert_equal 'Test Person', result[:name]
    assert_equal 'No Where Street', result[:address][:street]
    assert_nil result[:address][:zip_code]
    assert_nil result[:address][:status]
  end
end
