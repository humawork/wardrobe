require 'test_helper'

class EqualityTest < TestBase
  class Person
    include Wardrobe
    plugin :equality
    attribute :name, String
    attribute :age, Integer, include_in_equality: false
  end

  class Alien
    include Wardrobe
    attribute :name, String
  end

  def setup
    @alien_1 = Alien.new(name: 'Rudolf')
    @alien_2 = Alien.new(name: 'Santa')
    @alien_3 = Alien.new(name: 'Rudolf')
    @person_1 = Person.new(name: 'Santa', age: 435)
    @person_2 = Person.new(name: 'Rudolf', age: 1)
    @person_3 = Person.new(name: 'Santa', age: 56)
  end

  def test_aliens
    refute @alien_1 == @alien_2
    refute @alien_2 == @alien_3
    refute @alien_3 == @alien_1
  end

  def test_people
    refute @person_1 == @person_2
    refute @person_2 == @person_3
    assert @person_1 == @person_3
  end
end
