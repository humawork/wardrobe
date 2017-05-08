# frozen_string_literal: true

require 'set'
module Atrs
  module Plugins
    module Coercible
      module Refinements
        refine Set.singleton_class do
          def coerce(v, _atr)
            case v
            when self then v
            when Array then v.to_set
            when NilClass then nil
            else
              raise UnsupportedError
            end
          end
        end
        refine Set do
          def coerce(v, _atr)
            case v
            when NilClass then self.class.new
            when Array, Set
              v.to_set.map! { |i| first.coerce(i, nil) }
            else
              raise UnsupportedError
            end
          end
        end
      end
    end
  end
end
