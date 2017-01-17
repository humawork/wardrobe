module Attributable
  module Plugins
    module Validations
      module Refinements
        refine NilClass do
          def in(arr)
            [false, 'nil']
          end
          def match(val)
            [false, 'nil']
          end

          # def gte(int)
          #   self >= int ? [true, nil] : [false, "integer #{self} violates greater than or equal to #{int}" ]
          # end
          #
          # def gt(int)
          #   return self > int, "Error"
          # end
          #
          # def eq(int)
          #   self == int ? [true, nil] : [false, "#{self} violates equality with #{int}"]
          # end
        end
      end
    end
  end
end
