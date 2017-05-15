# frozen_string_literal: true

module Wardrobe
  module Plugins
    module Validation
      module Refinements
        refine String do
          include Size

          alias_method :original_empty?, :empty?

          def empty?
            return if original_empty?
            'must be empty'
          end

          def filled?
            return unless self.strip == ''
            'must be filled'
          end

          def format?(regex)
            return if regex.match(self)
            'is in invalid format'
          end

          def in(array)
            return unless array.include?(self)
            "\"#{self}\" is not included in '#{array.inspect}'"
          end

          alias_method :original_size, :size

          def size(range)
            unless range === original_size
              "\"#{self}\" violates length in range #{range}"
            end
          end

          def max_size(int)
            unless original_size <= int
              "\"#{self}\" has two many characters. Maximum #{int}"
            end
          end

          def min_size(int)
            unless original_size >= int
              "length cannot be less than #{int}"
            end
          end
        end
      end
    end
  end
end
