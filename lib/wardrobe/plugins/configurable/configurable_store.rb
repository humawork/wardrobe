# frozen_string_literal: true

module Wardrobe
  module Plugins
    module Configurable
      class ConfigurableStore < Store
        using ImmutableInstanceMethods
        def register(name, klass)
          mutate do
            store.merge!(name => klass.new.freeze)
          end
        end

        def update(name, klass, &blk)
          if frozen?
            dup.update(name, klass, &blk)
          else
            duplicate = @store[name].mutate(_options: { klass: klass }, &blk)
            @store = @store.merge(name => duplicate)
            freeze
          end
        end
      end
    end
  end
end
