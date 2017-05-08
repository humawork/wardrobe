# frozen_string_literal: true

module Atrs
  module Plugins
    module Coercible
      module Refinements
        refine Symbol.singleton_class do
          def coerce(v, _atr)
            case v
            when self     then v
            when String   then v.to_sym
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
