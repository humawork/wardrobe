module Attributable
  module Plugins
    module Validations
      module Refinements
        refine Object do
          def not_nil(value)
            self.nil? == value ? [false, "Required attribute. Can't be null."] : [true, nil]
          end

          def nil(value)
            !not_nil(value)
          end
        end
      end
    end
  end
end
