module Atrs
  class RootConfig
    attr_reader :default_plugins
    def initialize
      @default_plugins = Set.new
    end

    def register_default_plugin(name)
      raise "error" unless Atrs.plugins.has_key?(name)
      @default_plugins.add(name)
    end
  end
end