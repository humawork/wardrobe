require 'test_helper'

class ParamConfig
  include Wardrobe
  plugin :immutable
  attribute :name, String
  attribute :klass, Symbol
end

class ChildTestConfig
  include Wardrobe
  plugin :immutable
  attribute :name, String
  attribute :params, Array[ParamConfig]
end

class TestConfig
  include Wardrobe
  plugin :immutable
  plugin :validation
  attribute :title, String, validates { filled? }
  attribute :proc_test, Proc
  attribute :child, ChildTestConfig
end

class TestConfigWithValidation
  include Wardrobe
  plugin :immutable
  plugin :validation
  attribute :foo, String, validates { filled? }
  attribute :bar, String
end

class Base
  include Wardrobe
  plugin :configurable

  configurable :config, :configure, TestConfig,
               before_update: ->(klass) { klass.before_called! },
               after_update: ->(klass) { klass.after_called! }

  def self.before_called!
    @before_array ||= []
    @before_array << self
  end

  def self.after_called!
    @after_array ||= []
    @after_array << self
  end

  configure do |config|
    config.title = 'Title'
    config.child.name = 'Child Title'
    config.proc_test = Proc.new { |input|
      puts "sdfsdf"
    }
  end
end

class Child < Base
  configure do |config|
    config.child.name = 'Modified Child Title'
  end
end

# class Child2 < Child
#   configure do |config|
#     # config.set(title: 'Title in Child2')
#     # config.title = 'Title in Child2'
#     # config.child.name = 'Name in Child2'
#   end
# end


class ConfigurableTest < TestBase
  def test_store_created_in_config
    assert Base.configurable_store
    assert Child.configurable_store
  end

  def test_child_class
    assert_equal 'Title', Base.config.title
    assert_equal 'Child Title', Base.config.child.name
  end

  def test_modified_child_class
    assert_equal 'Title', Child.config.title
    assert_equal 'Modified Child Title', Child.config.child.name
  end

  def test_callbacks
    assert_equal [Base], Base.instance_variable_get(:@before_array)
    assert_equal [Base], Base.instance_variable_get(:@after_array)
    assert_equal [Child], Child.instance_variable_get(:@before_array)
    assert_equal [Child], Child.instance_variable_get(:@after_array)
    Child.configure {}
    assert_equal [Child, Child], Child.instance_variable_get(:@before_array)
    assert_equal [Child, Child], Child.instance_variable_get(:@after_array)
  end

  def test_validation
    assert_raises(Wardrobe::Plugins::Validation::ValidationError) do
      Class.new do
        include Wardrobe
        plugin :configurable
        configurable :config, :configure, TestConfigWithValidation
        configure {}
      end
    end
  end
end
