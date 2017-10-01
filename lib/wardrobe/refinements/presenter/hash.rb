# frozen_string_literal: true

module Wardrobe
  module Refinements
    module Presenter
      refine Hash do
        def _set_at(value, segments)
          segment = segments.shift
          if segments.empty?
            self[segment] = value
          else
            self[segment] ||= {}
            self[segment]._set_at(value, segments)
          end
        end

        def _present(attributes: nil, **options)
          {}.tap do |res|
            each do |k,v|
              key = k._present(attributes: nil, **options)
              val = v._present(attributes: (attributes ? attributes[k] : nil), **options)
              res[key] = val
            end
          end
        end
      end
    end
  end
end
