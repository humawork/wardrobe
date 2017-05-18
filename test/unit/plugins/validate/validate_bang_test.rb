require 'test_helper'

class ValidationBangTest < TestBase
  class Foo
    include Wardrobe
    plugin :validation
    attribute :name, String, validates { min_size?(10) }
    attribute :gender, String, validates { optional { size?(1) | format?(/^a/) }}
  end

  def test_error
    assert_raises(Wardrobe::Plugins::Validation::ValidationError) do
      object = Foo.new(name: 'Foo', gender: 'male')
      object._validate!
    end
  end

  def test_error_string
    begin
      Foo.new(name: 'Foo', gender: 'male')._validate!
    rescue Wardrobe::Plugins::Validation::ValidationError => e
      assert e.to_s.is_a?(String)
    end
  end

  def test_success
    instance = Foo.new(name: 'Foo Bar Long', gender: 'a')._validate!
    assert instance.is_a?(Foo)
  end
end
