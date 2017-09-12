# frozen_string_literal: true

module Wardrobe
  module Plugins
    module Configurable
      class ConfigurableStore < Store
        using ImmutableInstanceMethods
        def register(name, klass)
          mutate do
            case klass
            when Hash
              store.merge!(name => Hash.new.freeze)
            else
              store.merge!(name => klass.new.freeze)
            end
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

        def update_hash(name, klass, hash_key, hash_klass, &blk)
          if frozen?
            dup.update_hash(name, klass, hash_key, hash_klass, &blk)
          else
            duplicate = @store[name].mutate(_options: { klass: klass }) do |hash|
              hash[hash_key] ||= hash_klass.new
              hash[hash_key] = hash[hash_key].mutate(_options: { klass: klass }, &blk)
            end
            @store = @store.mutate do |store|
              store[name] = store[name].merge(duplicate)
            end
            freeze
          end
        end
      end
    end
  end
end
