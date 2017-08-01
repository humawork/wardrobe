require 'test_helper'

class ConfigurableModuleTest < TestBase
  class Foo
    include Wardrobe
    plugin :immutable
    attribute :name, String
  end

  class Bar < Foo
    plugin :validation, validate_on_set: true
    attribute :name, String, validates { min_size?(1) }
  end

  class Animal
    include Wardrobe
    plugin :configurable
    configurable :config, :configure, Foo
  end

  class Dog < Animal
    configurable :config, :configure, Bar
  end

  def test_config
    assert_raises(Wardrobe::Plugins::Validation::ValidationError) do
      Dog.class_exec do
        configure do |config|
          config.name = ''
        end
      end
    end
  end
end
