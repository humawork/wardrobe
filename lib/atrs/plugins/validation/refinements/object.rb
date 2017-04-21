module Atrs
  module Plugins
    module Validation
      module Refinements
        refine Object do
          def not_nil(value)
            return unless self.nil?
            "Required attribute. Can't be null."
          end

          def if(value)
            if value[:check] == self
              value[true].call
              binding.pry
            else
              binding.pry
            end
          end

          def nil(value)
            !not_nil(value)
          end
        end
      end
    end
  end
end
