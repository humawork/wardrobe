# frozen_string_literal: true

require_relative 'presenter/refinements'
module Atrs
  module Plugins
    module Presenter
      extend Atrs::Plugin

      module InstanceMethods
        using Refinements
        def _present(atrs: nil)
          result = {}
          _attribute_store.store.each do |key, atr|
            if atrs.nil? || (atrs && atrs.key?(key))
              result[key] = send(atr.name)._present(atrs: (atrs[key] if atrs))
            end
          end
          result
        end
      end
    end
  end
  register_plugin(:presenter, Plugins::Presenter)
end
