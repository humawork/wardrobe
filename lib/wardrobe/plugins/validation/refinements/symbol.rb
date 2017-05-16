# frozen_string_literal: true

module Wardrobe
  module Plugins
    module Validation
      module Refinements
        refine Symbol do
          def empty?
            return if self.to_s.strip == ''
            'must be empty'
          end

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
