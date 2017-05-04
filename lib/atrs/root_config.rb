# frozen_string_literal: true

module Atrs
  # Config class used on Atrs root module
  class RootConfig
    include Atrs
    plugin :immutable
    plugin :default
    attribute :coerce, Boolean, default: true
    attribute :default_plugins, Set[Symbol], default: Set.new([:coercible])

    def register_default_plugin(name)
      raise 'error' unless Atrs.plugins.key?(name)
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
