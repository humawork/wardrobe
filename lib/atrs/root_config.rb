# frozen_string_literal: true

module Atrs
  # Config class used on Atrs root module
  class RootConfig
    include Atrs
    plugin :immutable
    plugin :default
    attribute :default_plugins, Set[Symbol]

    def register_default_plugin(name)
      raise 'error' unless Atrs.plugins.key?(name)
      default_plugins.add(name)
    end

    def build(**args)
      args.each do |k, v|
        send("#{k}=", v)
      end
      self
    end
  end
end
