# frozen_string_literal: true

module Wardrobe
  class PluginNameTakenError < StandardError; end
  class PluginOptionKeywordTakenError < StandardError; end
  class MisconfiguredPluginError < StandardError; end

  class << self
    attr_reader :plugins, :options
  end
  @plugins = {}
  @options = {}

  def self.register_plugin(name, mod)
    raise PluginNameTakenError, "Plugin #{name} already in use" if plugins[name]
    plugins[name] = mod
  end

  module Plugin
    def options
      @options ||= []
    end

    def required_plugins
      @required_plugins ||= []
    end

    def plugin(name)
      required_plugins << name
    end

    def after_load(&blk)
      @after_load = blk if block_given?
      @after_load if instance_variable_defined?(:@after_load)
    end

    def option(name, klass, **kargs, &blk)
      raise PluginOptionKeywordTaken if Wardrobe.options[name]
      option_instance = Option.new(name, klass, self, **kargs, &blk)
      Wardrobe.options[name] = option_instance
      BlockSetup.register_option(option_instance)
      options << option_instance
    end
  end
end
