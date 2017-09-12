require 'test_helper'

class ConfigurableHashTest < TestBase
  class TestConfig
    include Wardrobe
    plugin :immutable
    attribute :title, String
    attribute :href, String
  end

  class Base
    include Wardrobe
    plugin :configurable

    configurable :links, :link, Hash[Symbol =>TestConfig]

    link :one do |l|
      l.title = 'Title'
      l.href = 'http://example.com'
    end
  end

  class Child < Base
    link :one do |l|
      l.title = 'Changed'
    end
    link :two do |l|
      l.title = 'Another Link'
    end
  end

  def test_base
    assert Base.links.frozen?
    assert Base.links[:one].frozen?
    assert_equal 'Title', Base.links[:one].title
    refute Base.links[:two]
  end

  def test_child
    assert_equal 'Changed', Child.links[:one].title
    assert_equal 'Another Link', Child.links[:two].title
  end
end
