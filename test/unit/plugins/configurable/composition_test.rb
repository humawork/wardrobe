require 'test_helper'

class ConfigurableCompositionTest < TestBase
  class Config
    include Wardrobe
    plugin :immutable
    attribute :name, Symbol
  end

  module One
    include Wardrobe
    plugin :configurable
    configurable :config, :configure, Config
    configure do |c|
      c.name = :mod_one
    end
  end

  class Bar
    include One
  end

  class BarChild < Bar
    configure do |c|
      c.name = :bar_child_class
    end
  end

  class NewConfig < Config

  end

  class BarUpdatedConfig
    include One
    configurable :config, :configure, NewConfig, after_update: ->(klass) { klass.after_called! }

    def self.after_called!
      @after_array ||= []
      @after_array << self
    end

    configure {}
  end

  def test_module_included_in_class
    assert_equal :mod_one, Bar.config.name
    assert_equal :bar_child_class, BarChild.config.name
    assert_equal [BarUpdatedConfig], BarUpdatedConfig.instance_variable_get(:@after_array)
  end
end
