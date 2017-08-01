# frozen_string_literal: true

module Wardrobe
  module Plugins
    module Validation
      module Refinements
        refine Symbol do
          include Size
          def empty?
            return if self.to_s.strip == ''
            'must be empty'
          end

          # def size?(predicate_value)
          #   puts "asdfasdf"
          #   binding.pry
          # end
          #
          # def min_size?(predicate_value)
          #   puts "asdfasdf"
          #   binding.pry
          # end

          def filled?
            return unless self.to_s.strip == ''
            'must be filled'
          end

          def format?(regex)
            return if regex.match(self)
            "must match #{regex.inspect}"
          end
        end
      end
    end
  end
end
