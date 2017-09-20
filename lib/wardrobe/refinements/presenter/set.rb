# frozen_string_literal: true

module Wardrobe
  module Refinements
    module Presenter
      refine Set do
        def _present(attributes: nil, **options)
          options[:path] ||= []
          options[:path] << self
          child_attributes = attributes&.dig(:_itm)
          map do |item|
            item._present(attributes: child_attributes, **options)
          end
        ensure
          options[:path].pop
        end
      end
    end
  end
end
