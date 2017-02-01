module Atrs
  module Plugins
    module Presenter
      module Refinements
        refine String do
          def _present(*args)
            self
          end
        end
      end
    end
  end
end
