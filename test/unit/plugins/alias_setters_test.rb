require 'test_helper'

class AliasPerson
  extend Atrs
  plugin :alias_setters
  attributes do
    alias_setter :profile_name do
      attribute :name, String, alias_setter: :full_name
    end
  end
end


class AliasSetterTest < Minitest::Test
  def test_block_setup_alias_setter
    person = AliasPerson.new(profile_name: 'Test Person')
    assert_equal 'Test Person', person.name
  end

  def test_attribute_alias_setter
    person = AliasPerson.new(full_name: 'Test Person')
    assert_equal 'Test Person', person.name
  end
end
