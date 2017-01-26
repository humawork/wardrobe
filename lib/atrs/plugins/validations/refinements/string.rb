module Atrs
  module Plugins
    module Validations
      module Refinements
        refine String do
          def match(regex)
            super ? [ true, nil ] : [false, "\"#{self}\" does not match regex '#{regex.inspect}'" ]
          end

          def in(array)
            array.include?(self) ? true : [false, "\"#{self}\" is not included in '#{array.inspect}'"]
          end

          alias_method :original_length, :length

          def length(range)
            range === original_length ? true : [false, "\"#{self}\" violates length in range #{range}"]
          end

          def max_length(int)
            original_length <= int ? true : [false, "\"#{self}\" has two many characters. Maximum #{int}"]
          end

          def min_length(int)
            original_length >= int ? true : [false, "\"#{self}\" has two few characters. Minium #{int}"]
          end
        end
      end
    end
  end
end
