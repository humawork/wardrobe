# frozen_string_literal: true

module Wardrobe
  module Plugins
    module Validation
      module Refinements
        refine Set do
          alias_method :original_empty?, :empty?

          include Size

          def empty?
            return if original_empty?
            'must be empty'
          end

          def filled?
            return unless original_empty?
            'must be filled'
          end
        end
      end
    end
  end
end
