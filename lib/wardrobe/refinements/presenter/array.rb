# frozen_string_literal: true

module Wardrobe
  module Refinements
    module Presenter
      refine Array do
        def _present(attributes: nil, **options)
          map do |item|
            item._present(attributes: attributes, **options)
          end
        end
      end
    end
  end
end
