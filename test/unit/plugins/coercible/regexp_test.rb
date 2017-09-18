require 'test_helper'

class RegexpCoercionTest < TestBase
  class RegexpObject
    include Wardrobe
    attribute :regexp, Regexp
    attribute :string, Regexp
  end

  def test_coercion
    object = RegexpObject.new(
      regexp: /.+/,
      string: '/.+/'
    )
    assert_equal Regexp, object.regexp.class
    assert_equal Regexp, object.string.class
    assert_equal '/.+/', object.regexp.inspect
    assert_equal '/.+/', object.string.inspect
  end

  def test_regexp_options
    assert_equal(/abc/i, RegexpObject.new(string: "/abc/i").string)
    assert_equal(/abc/u, RegexpObject.new(string: "/abc/u").string)
    assert_equal(/abc/m, RegexpObject.new(string: "/abc/m").string)
    assert_equal(/abc/x, RegexpObject.new(string: "/abc/x").string)
    assert_equal(/abc/mix, RegexpObject.new(string: "/abc/imx").string)
  end

  def test_invalid_rexex_string
    assert_raises Wardrobe::Coercible::UnsupportedError do
      RegexpObject.new(string: "abc/i")
    end

  end

  def test_error
    assert_raises Wardrobe::Coercible::UnsupportedError do
      RegexpObject.new(
        regexp: 1
      )
    end
  end
end
