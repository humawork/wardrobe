require 'test_helper'

class ImmutableConfigurableHashTest < TestBase

  class Foo
    include Wardrobe
    plugin :immutable
    attribute :name, String
  end

  class Immutable
    include Wardrobe
    plugin :immutable
    plugin :coercible_open_struct
    attribute :hash, Hash[Symbol => Foo]
    attribute :open_struct, OpenStruct(Foo)
  end

  def test_hash
    instance = Immutable.new
    mutated = instance.mutate do |inst|
      inst.hash[:foo] = {}
      refute inst.hash[:foo].frozen?
      inst.hash[:foo].name = :bar
    end

    assert mutated.hash[:foo]
    assert_equal 'bar', mutated.hash[:foo].name
  end

  def test_open_struct
    instance = Immutable.new
    mutated = instance.mutate do |inst|
      inst.open_struct.foo = {}
      refute inst.open_struct.foo.frozen?
      inst.open_struct.foo.name = :bar
    end

    assert mutated.open_struct.foo
    assert_equal 'bar', mutated.open_struct.foo.name
  end
end
