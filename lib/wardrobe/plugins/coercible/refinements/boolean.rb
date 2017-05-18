# frozen_string_literal: true

module Wardrobe
  module Plugins
    module Coercible
      module Refinements
        TRUE_STRINGS = Set.new(['1', 'yes', 'true']).freeze
        FALSE_STRINGS = Set.new(['0', 'no', 'false']).freeze
        refine Wardrobe::Boolean.singleton_class do
          def coerce(v, _atr)
            case v
            when TrueClass, FalseClass then v
            when Integer then integer(v)
            when String then string(v)
            when NilClass then nil
            else
              raise UnsupportedError
            end
          end

          def integer(v)
            return false if v == 0
            return true if v == 1
            raise UnsupportedError
          end

          def string(v)
            return false if FALSE_STRINGS.include?(v)
            return true if TRUE_STRINGS.include?(v)
            raise UnsupportedError
          end
        end
      end
    end
  end
end
