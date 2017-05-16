# frozen_string_literal: true

module Wardrobe
  module Plugins
    module Validation
      module ClassMethods
        def validates(&blk)
          { validates: BlockHandler.new(&blk).result }
        end
      end
    end
  end
end
