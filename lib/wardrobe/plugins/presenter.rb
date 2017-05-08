# frozen_string_literal: true

require_relative 'presenter/refinements'
module Wardrobe
  module Plugins
    module Presenter
      extend Wardrobe::Plugin

      module InstanceMethods
        using Refinements
        def _present(wardrobe: nil)
          result = {}
          _attribute_store.store.each do |key, atr|
            if wardrobe.nil? || (wardrobe && wardrobe.key?(key))
              result[key] = send(atr.name)._present(wardrobe: (wardrobe[key] if wardrobe))
            end
          end
          result
        end
      end
    end
  end
  register_plugin(:presenter, Plugins::Presenter)
end
