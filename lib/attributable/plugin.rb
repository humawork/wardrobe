module Attributable
  class PluginNameTaken < StandardError; end
  class PluginOptionKeywordTaken < StandardError; end

  @plugins = {}
  @options = {}

  def self.plugins; @plugins; end
  def self.options; @options; end

  def self.register_plugin(name, mod)
    raise PluginNameTaken, "Plugin #{name} already in use" if plugins[name]
    plugins[name] = mod
  end

  module Plugin
    def self.extended(base)
      name = base.to_s[/::([^:]+)$/,1]
                 .gsub(/([a-z])([A-Z])/, '\1_\2')
                 .downcase.to_sym
      Attributable.register_plugin(name, base)
    end

    def setter(&blk)
      if block_given?
        @setter = blk
      else
        @setter ||= nil
      end
      # return @setter unless block_given?
      # @setter = blk
    end

    def option_klass; @option_klass; end
    def option_name; @option_name; end

    def instance_methods_module
      const_get(:InstanceMethods)
    rescue NameError
      nil
    end

    def class_methods_module
      const_get(:ClassMethods)
    rescue NameError
      nil
    end

    def option(name, klass, default: nil)
      # TODO: Refactor this to apply only if plugin is in use
      # THOUGHT: Should we support a set of default options enabled globaly?

      raise PluginOptionKeywordTaken if Attributable.options[:name]
      # These needs to go somewhere else
      @option_name = name
      @option_klass = klass
      @option_default = default
      Attributable.options[name] = self
      BlockRunner.add_plugin(self)
    end
  end
end
