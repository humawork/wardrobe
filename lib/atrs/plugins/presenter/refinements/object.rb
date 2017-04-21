module Atrs
  module Plugins
    module Presenter
      module Refinements
        refine Object do
          def _present(*args)
            self
          end
        end
      end
    end
  end
end
