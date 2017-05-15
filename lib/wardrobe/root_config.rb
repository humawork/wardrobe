# frozen_string_literal: true

module Wardrobe
  # Config class used on Wardrobe root module
  class RootConfig
    include Wardrobe
    plugin :immutable
    plugin :default
    attribute :coerce, Boolean, default: true
    attribute :logger, Object, default: ->() { Logger.new(STDOUT) }
    attribute :default_plugins, Set[Symbol], default: Set.new([:coercible])

    def register_default_plugin(name)
      raise 'error' unless Wardrobe.plugins.key?(name)
      default_plugins.add(name)
    end

    def coerce=(value)
      if super == false
        default_plugins.delete(:coercible)
      end
    end

    def build(**args)
      args.each do |k, v|
        send("#{k}=", v)
      end
      self
    end
  end
end
