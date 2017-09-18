# frozen_string_literal: true

module Wardrobe
  module Plugins
    module Presenter
      module Refinements
        refine Hash do
          def _set_at(value, segments)
            segment = segments.shift
            if segments.empty?
              self[segment.to_sym] = value
            else
              self[segment.to_sym] ||= {}
              self[segment.to_sym]._set_at(value, segments)
            end
          end
          def _present(*_args)
            transform_values(&:_present)
          end
        end
      end
    end
  end
end
