# frozen_string_literal: true

module Atrs
  module Plugins
    module Coercible
      module Refinements
        refine Integer.singleton_class do
          def coerce(v, _atr)
            case v
            when self          then v
            when String, Float then v.to_i
            when Time          then v.to_i
            when Date          then v.to_time.to_i
            when NilClass      then nil
            else
              raise UnsupportedError
            end
          end
        end
      end
    end
  end
end