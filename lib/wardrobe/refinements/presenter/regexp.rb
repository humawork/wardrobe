# frozen_string_literal: true

module Wardrobe
  module Refinements
    module Presenter
      refine Regexp do
        def _present(**options)
          to_s[/^\(\?-mix:(.+)\)$/,1]
        end
      end
    end
  end
end
