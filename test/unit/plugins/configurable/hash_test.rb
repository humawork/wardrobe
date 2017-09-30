require 'test_helper'

class ConfigurableHashTest < TestBase
  class Link
    include Wardrobe
    plugin :immutable
    attribute :title, String
    attribute :href, String
  end

  class LinkStore
    include Wardrobe
    include Enumerable
    extend Forwardable
    plugin :immutable
    attribute :links, Hash[Symbol => Link]

    def_delegators :@links, :[]

    def each(&block)
      @links.each(&block)
    end

    def configurable_update(name, **kargs, &blk)
      if links[name]
        kargs.each do |k,v|
          links[name].send("#{k}=", v)
        end
      else
        links[name] = Link.new(kargs)
      end
      blk.call(links[name]) if blk
    end

    def merge(other)
      mutate do |copy|
        copy.links.merge!(other.links)
      end
    end
  end

  module ModuleLink
    include Wardrobe
    plugin :configurable

    configurable :links, :link, LinkStore

    link :from_module do |l|
      l.title = 'Link added from module'
    end
  end

  class Base
    include Wardrobe
    plugin :configurable

    configurable :links, :link, LinkStore

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

  class ChildWithModule < Base
    include ModuleLink
  end

  def test_base
    assert Base.links.frozen?
    assert Base.links[:one].frozen?
    assert_equal 'Title', Base.links[:one].title
    refute Base.links[:two]
  end

  def test_child_with_module
    assert_equal 2, ChildWithModule.links.links.length
  end

  def test_child
    assert_equal 'Changed', Child.links[:one].title
    assert_equal 'Another Link', Child.links[:two].title
  end

  def test_other
    klass = Class.new(Child) do
      link :three, title: 'Link 3'
    end
    assert_equal 'Link 3', klass.links[:three].title
  end
end
