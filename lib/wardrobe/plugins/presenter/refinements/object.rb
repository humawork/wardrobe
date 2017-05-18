# frozen_string_literal: true

module Wardrobe
  module Plugins
    module Presenter
      module Refinements
        refine Object do
          def _present(*_args)
            self
          end
        end
      end
    end
  end
end
