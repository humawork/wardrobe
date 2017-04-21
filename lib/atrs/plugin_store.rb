module Atrs
  class PluginStore < Store
    attr_reader :store
    def add(name)
      begin
        plugin = Atrs.plugins.fetch(name)
      rescue KeyError
        raise "No plugin #{name} registered"
      end
      mutate do
        store[name] = plugin
      end
    end
  end
end
