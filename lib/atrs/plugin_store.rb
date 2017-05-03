# frozen_string_literal: true

module Atrs
  class PluginStore < Store
    attr_reader :store
    def add(name)
      begin
        plugin = Atrs.plugins.fetch(name)
      rescue KeyError
        if require "atrs/plugins/#{name}"
          retry
        else
          raise "No plugin #{name} registered"
        end
      end
      mutate do
        store[name] = plugin
      end
    end
  end
end
