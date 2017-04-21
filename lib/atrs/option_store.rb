module Atrs
  class OptionStore < Store
    attr_reader :store, :defaults

    def freeze
      init_defaults
      super
    end

    def add(name, instance)
      mutate {
        store[name] = instance
      }
    end

    private

    def init_defaults
      @defaults = store.select { |k,v| !v.default.nil? }
                     .transform_values { |v| v.default }
    end
  end
end
