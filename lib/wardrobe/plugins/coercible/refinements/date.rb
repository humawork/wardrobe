# frozen_string_literal: true

# rubocop:disable Metrics/CyclomaticComplexity

require 'date'
module Wardrobe
  module Plugins
    module Coercible
      module Refinements
        refine Date.singleton_class do
          def coerce(v, _atr)
            case v
            # DateTime has to be first. `DateTime.new === Date.new # => true`
            when DateTime then v.to_date
            when self     then v
            when String   then Date.parse(v)
            when Time     then v.to_date
            when Integer  then Time.at(v).to_date
            when Float    then Time.at(v).to_date
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

# rubocop:enable Metrics/CyclomaticComplexity
