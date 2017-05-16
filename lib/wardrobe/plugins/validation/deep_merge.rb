# frozen_string_literal: true

module Wardrobe
  module Plugins
    module Validation

      module DeepMerge
        refine Array do
          def deep_merge!(other)
            self.push(*other)
          end
        end
        refine Hash do
          def deep_merge!(other)
            other.each do |key, value|
              if has_key?(key)
                self[key].deep_merge!(value)
              else
                self[key] = value
              end
            end
          end
        end
      end
    end
  end
end
