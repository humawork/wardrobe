require 'test_helper'

class MethodOverrideTest < TestBase
  class Person
    include Wardrobe
    plugin :nil_if_empty
    attribute :name, String, nil_if_empty: true

    def name
      super + ' added'
    end
  end

  def test_one
    person = Person.new(name: 'hi')
    assert_equal 'hi added', person.name
  end
end
