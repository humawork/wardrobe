module Atrs
  module Plugins
    module Configurable
      class ConfigurableStore < Store
        using ImmutableInstanceMethods
        def register(name, klass)
          mutate do
            store.merge!(name => klass.new.freeze)
          end
        end

        def update(name, &blk)
          if frozen?
            dup.update(name, &blk)
          else
            duplicate = @store[name].mutate(&blk)
            # binding.pry
            @store = @store.merge(name => duplicate)
            freeze
          end
        end
      end
    end
  end
end
