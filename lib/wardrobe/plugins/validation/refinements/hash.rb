# frozen_string_literal: true

module Wardrobe
  module Plugins
    module Validation
      module Refinements
        refine ::Hash do
          include Size

          alias_method :original_empty?, :empty?

          def empty?
            return if original_empty?
            'must be empty'
          end

          alias_method :old_each_key, :each_key

          def filled?
            return unless original_empty?
            'must be filled'
          end
        end
      end
    end
  end
end
