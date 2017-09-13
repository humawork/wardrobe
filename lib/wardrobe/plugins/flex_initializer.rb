# frozen_string_literal: true

module Wardrobe
  module Plugins
    module FlexInitializer
      extend Wardrobe::Plugin

      module InstanceMethods
        using Refinements::DeepSymbolizeKeys
        def initialize(arg = nil, **hash)
          if arg
            raise ArgumentError, 'Initialize wardrobe with a hash and/or key args' unless arg.is_a?(Hash)
            hash = arg.deep_symbolize_keys.merge(hash)
          end
          super(**hash)
        end
      end
    end
  end
  register_plugin(:flex_initializer, Plugins::FlexInitializer)
end
