require 'test_helper'

class ProcCoercionTest < TestBase
  class ProcObject
    include Wardrobe
    attribute :proc, Proc
  end

  def test_coercion
    object = ProcObject.new(
      proc: Proc.new { 1 }
    )

    assert_equal Proc, object.proc.class
    assert_equal 1, object.proc.call
  end

  def test_error
    assert_raises Wardrobe::Coercible::UnsupportedError do
      ProcObject.new(
        proc: 1
      )
    end
  end
end
