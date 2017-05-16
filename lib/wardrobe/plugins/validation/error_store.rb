# frozen_string_literal: true

module Wardrobe
  module Plugins
    module Validation
      class ErrorStore
        attr_reader :store

        using DeepMerge
        def initialize
          @store = Hash.new { |hash, key| hash[key] = Array.new }
        end

        def add(atr, *errors)
          errors.each do |error|
            if error.is_a? String
              @store[atr.name] << error
            else
              @store[atr.name].unshift({}) unless @store[atr.name].first.is_a?(Hash)
              @store[atr.name].first.deep_merge!(error)
            end
          end
        end
      end
    end
  end
end
