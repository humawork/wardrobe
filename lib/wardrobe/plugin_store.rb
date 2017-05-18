# frozen_string_literal: true

module Wardrobe
  class NoPluginRegisteredError < StandardError; end

  class PluginStore < Store
    attr_reader :store
    def add(name, **args)
      begin
        plugin = Wardrobe.plugins.fetch(name)
      rescue KeyError
        begin
          if require "wardrobe/plugins/#{name}"
            retry
          end
        rescue LoadError
          raise NoPluginRegisteredError, name
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
