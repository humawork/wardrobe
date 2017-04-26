# frozen_string_literal: true

module Atrs
  module Plugins
    module Presenter
      module Refinements
        refine Array do
          def _present(*args)
            each(&:_present)
          end
        end
      end
    end
  end
end
