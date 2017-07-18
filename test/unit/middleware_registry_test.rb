require 'test_helper'

class MiddlewareRegistryTest < TestBase
  def middleware(name)
    Wardrobe::Middleware.new(name, ->(){}, ->(){})
  end

  def test_multiple_middleware_with_no_priorities
    registry = Wardrobe::MiddlewareRegistry.new
    registry.register(middleware(:one), [], [])
    registry.register(middleware(:two), [], [])
    registry.register(middleware(:three), [], [])
    assert_equal [:one, :two, :three], registry.order.map(&:name)
  end

  def test_multiple_middleware_with_illegal_order
    registry = Wardrobe::MiddlewareRegistry.new
    assert_raises(Wardrobe::MiddlewareOrderError) do
      registry.register(middleware(:two), [:one], [])
      registry.register(middleware(:one), [:two], [])
    end
  end

  def test_complex_before_after_ordering
    registry = Wardrobe::MiddlewareRegistry.new
    registry.register(middleware(8), [9,10], [1,7])
    registry.register(middleware(1), [10], [])
    registry.register(middleware(4), [8], [1])
    registry.register(middleware(3), [4], [2])
    registry.register(middleware(6), [10], [1,2,3,4,5])
    registry.register(middleware(7), [8,10], [6,3,4])
    registry.register(middleware(2), [7,3,6], [])
    registry.register(middleware(5), [6,7], [4,2])
    registry.register(middleware(10), [], [2,9])
    registry.register(middleware(9), [], [8])
    assert_equal [1,2,3,4,5,6,7,8,9,10], registry.order.map(&:name)
  end
end
