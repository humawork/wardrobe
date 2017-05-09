# frozen_string_literal: true

module Wardrobe
  class PluginStore < Store
    attr_reader :store
    def add(name, **args)
      begin
        plugin = Wardrobe.plugins.fetch(name)
      rescue KeyError
        if require "wardrobe/plugins/#{name}"
          retry
        else
          raise "No plugin #{name} registered"
        end
      end
      mutate do
        store[name] = {
          klass: plugin,
          options: args
        }
      end
    end
  end
end
