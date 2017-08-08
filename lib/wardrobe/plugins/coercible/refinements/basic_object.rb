# frozen_string_literal: true

module Wardrobe
  module Plugins
    module Coercible
      module Refinements
        refine BasicObject.singleton_class do
          def coerce(v, _atr, _parent)
            v
          end
        end
      end
    end
  end
end
