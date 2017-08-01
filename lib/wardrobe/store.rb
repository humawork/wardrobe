# frozen_string_literal: true

module Wardrobe
  class Store
    include Enumerable
    attr_reader :store, :parent

    def initialize
      @store = {}
      freeze
    end

    def values
      store.values
    end

    def [](name)
      store[name]
    end

    def each(&blk)
      store.each(&blk)
    end

    def freeze
      store.freeze
      super
    end

    def method_missing(name, *args, **key_args, &block)
      if (atr = store[name])
        atr
      else
        super
      end
    end

    def merge(other, _calling_object, _config)
      mutate do
        @store = store.merge(other.store)
      end
    end

    def del(name)
      mutate do
        store.delete(name) { |key| raise "#{key} not found" }
      end
    end

    private

    def mutate(&blk)
      dup.instance_exec do
        @store = store.dup
        instance_exec(&blk)
        freeze
      end
    end
  end
end
