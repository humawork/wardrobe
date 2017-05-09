# frozen_string_literal: true

require_relative 'presenter/refinements'
module Wardrobe
  module Plugins
    module Presenter
      extend Wardrobe::Plugin

      module InstanceMethods
        using Refinements
        def _present(attributes: nil, **args)
          options = self.class.plugin_store[:presenter][:options].merge(args)
          result = {}
          _attribute_store.store.each do |key, atr|
            if attributes.nil? || (attributes && attributes.key?(key))
              result[key] = send(atr.name)._present(attributes: (attributes[key] if attributes), **options)
            end
          end
          result
        end
      end
    end
  end
  register_plugin(:presenter, Plugins::Presenter)
end
