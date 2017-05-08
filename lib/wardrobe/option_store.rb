# frozen_string_literal: true

module Wardrobe
  class OptionStore < Store
    attr_reader :store, :defaults

    def freeze
      @defaults = select_defaults
      super
    end

    def add(name, instance)
      mutate { store[name] = instance }
    end

    private

    def select_defaults
      store.reject { |_k, v| v.default.nil? }.transform_values(&:default)
    end
  end
end
