module Atrs
  class PluginSet
    attr_reader :set

    def initialize
      @set = {}
      freeze
    end

    def [](name)
      set[name]
    end

    def length
      set.length
    end

    def each(&blk)
      set.each(&blk)
    end

    def freeze
      set.freeze
      super
    end

    def method_missing(name, *args, **key_args, &block)
      if atr = set[name]
        atr
      else
        super
      end
    end

    def merge(other)
      if frozen?
        dup.merge(other)
      else
        @set = set.merge(other.set)
        freeze
      end
    end

    def del(name)
      if frozen?
        dup.del(name)
      else
        @set = set.dup
        set.delete(name) { |key| raise "#{key} not found" }
        freeze
      end
    end

    def add(name)
      begin
        plugin = Atrs.plugins.fetch(name)
      rescue KeyError
        raise "No plugin #{name} registered"
      end
      if frozen?
        dup.add(name)
      else
        @set = set.dup
        set[name] = plugin
        freeze
      end
    end
  end
end
