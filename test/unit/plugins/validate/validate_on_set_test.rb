require 'test_helper'

class ValidationOnSetTest < TestBase
  class Foo
    include Wardrobe
    plugin :validation, validate_on_init: true, validate_on_set: true
    attribute :name, String, validates { min_size?(10) }
    attribute :gender, String, validates { optional { size?(1) | format?(/^a/) }}
  end

  def test_init
    no_log do
      assert_raises(Wardrobe::Plugins::Validation::ValidationError) do
        Foo.new(name: 'bar')
      end
    end
  end

  def test_setter
    no_log do
      foo = Foo.new(name: 'A Long Valid Name')
      assert_raises(Wardrobe::Plugins::Validation::ValidationError) do
        foo.name = 'bar'
      end
    end
  end
end
