module Attributable
  class PluginNameTaken < StandardError; end
  class PluginOptionKeywordTaken < StandardError; end

  def self.plugins
    @plugins ||= {}
  end

  def self.options
    @options ||= {}
  end

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
      return @setter unless block_given?
      @setter = blk
    end

    def option_klass; @option_klass; end
    def option_name; @option_name; end

    def option(name, klass)
      raise PluginOptionKeywordTaken if Attributable.options[:name]
      @option_name = name
      @option_klass = klass
      Attributable.options[name] = self
      BlockRunner.add_plugin(self)
    end
  end
end
