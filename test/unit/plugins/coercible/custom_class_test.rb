require 'test_helper'

class CustomClassTest < TestBase
  class CustomClass
    attr_reader :data
    def initialize(input)
      @data = input
    end
  end


  class CustomClassWithCoercion
    attr_reader :one, :two

    def initialize(one, two)
      @one = one
      @two = two
    end
  end

  Wardrobe::Coercible.add_coercer(Array => CustomClassWithCoercion) do |val, klass|
    klass.new(*val)
  end

  class WardrobeClass
    include Wardrobe
    attribute :string, String
    attribute :custom, CustomClass
    attribute :custom_coerce, CustomClassWithCoercion
  end

  def test_coercion
    object = WardrobeClass.new(
      string: :foo,
      custom: :bar,
      custom_coerce: [1,2]
    )

    assert_equal 'foo', object.string
    assert_equal :bar, object.custom.data
    assert_equal 1, object.custom_coerce.one
    assert_equal 2, object.custom_coerce.two
  end

  def test_error
    assert_raises(ArgumentError) do
      WardrobeClass.new(
        custom_coerce: [1, 2, 3]
      )
    end

    assert_raises(Wardrobe::Coercible::UnsupportedError) do
      WardrobeClass.new(
        custom_coerce: 1
      )
    end
  end
end
