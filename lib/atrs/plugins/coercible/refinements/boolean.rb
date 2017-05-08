# frozen_string_literal: true

module Atrs
  module Plugins
    module Coercible
      module Refinements
        TRUE_STRINGS = Set.new(['1', 'yes', 'true']).freeze
        FALSE_STRINGS = Set.new(['0', 'no', 'false']).freeze
        refine Atrs::Boolean.singleton_class do
          def coerce(v, atr)
            case v
            when TrueClass, FalseClass then v
            when Integer
              return false if v == 0
              return true if v == 1
              raise UnsupportedError
            when String
              return false if FALSE_STRINGS.include?(v)
              return true if TRUE_STRINGS.include?(v)
              raise UnsupportedError
            when NilClass then nil
            else
              raise UnsupportedError
            end
          end
        end
      end
    end
  end
end
