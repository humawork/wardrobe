require 'test_helper'

class AtrsConfigTest < Minitest::Test

  Atrs.configure do |config|
    config.register_default_plugin :default
  end

  class Person
    include Atrs

    attribute :name, String, default: 'Example Person'
  end

  def test_one
    assert_equal 'Example Person', Person.new.name
  end
end
