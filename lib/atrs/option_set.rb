module Atrs
  class OptionSet
    include Enumerable
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

    def add(name, instance)
      if frozen?
        dup.add(name, instance)
      else
        @set = set.dup
        set[name] = instance
        freeze
      end
    end
  end
end
