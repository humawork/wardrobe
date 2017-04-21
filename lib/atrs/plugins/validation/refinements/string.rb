module Atrs
  module Plugins
    module Validation
      module Refinements
        refine String do
          def match(regex)
            return if super
            "\"#{self}\" does not match regex '#{regex.inspect}'"
          end

          def in(array)
            return unless array.include?(self)
            "\"#{self}\" is not included in '#{array.inspect}'"
          end

          alias_method :original_length, :length

          def length(range)
            unless range === original_length
              "\"#{self}\" violates length in range #{range}"
            end
          end

          def max_length(int)
            unless original_length <= int
              "\"#{self}\" has two many characters. Maximum #{int}"
            end
          end

          def min_length(int)
            unless original_length >= int
              "length cannot be less than #{int}"
            end
          end
        end
      end
    end
  end
end
