require 'test_helper'
class DefineGetterTest < TestBase
  class Zero
    include Wardrobe
    plugin :optional_getter
    attribute :name, String, getter: false
  end

  class One
    include Wardrobe
    attribute :name,   String
  end

  class Two < One
    def name
      'overridden in two'
    end
  end

  module ModOne
    def name
      'overridden in mod one'
    end
  end

  class Three < Two
    include ModOne
  end

  module Part1
    def name
      'overridden in mod part_1'
    end
  end

  module Part2
    def name
      'overridden in mod part_2'
    end
    def email
      'email overridden in mod part_2'
    end
  end

  module Part3
    include Wardrobe
    attribute :email, String
  end

  module ComposedModule
    include Part1
    include Part2
    include Part3
  end

  class Four < Three
    include ComposedModule
  end

  class Five < Three
    include Part3
    include Part2
    include Part1
  end


  def test_class_zero
    assert_raises(NoMethodError) {
      Zero.new.name
    }
  end

  def test_class_one
    assert_nil One.new.name
  end

  def test_class_two
    assert_equal 'overridden in two', Two.new.name
  end

  def test_class_three
    assert_equal 'overridden in mod one', Three.new.name
  end

  def test_class_four
    assert_equal 'overridden in mod part_2', Four.new.name
    assert_nil Four.new.email
  end

  def test_class_five
    assert_equal 'email overridden in mod part_2', Five.new.email
    assert_equal 'overridden in mod part_1', Five.new.name
  end
end
