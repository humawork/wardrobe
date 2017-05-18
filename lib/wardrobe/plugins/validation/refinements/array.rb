# frozen_string_literal: true

module Wardrobe
  module Plugins
    module Validation
      module Refinements
        refine ::Array do

          alias_method :original_empty?, :empty?

          def empty?
            return if original_empty?
            'must be empty'
          end

          include Size

          def filled?
            return unless original_empty?
            'must be filled'
          end
        end
      end
    end
  end
end
