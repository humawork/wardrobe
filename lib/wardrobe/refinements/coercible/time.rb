# frozen_string_literal: true

# rubocop:disable Metrics/CyclomaticComplexity

require 'time'

module Wardrobe
  module Refinements
    module Coercible
      refine Time.singleton_class do
        def coerce(v, _atr, _parent)
          case v
          when self     then v
          when String   then Time.parse(v)
          when Integer  then Time.at(v)
          when Float    then Time.at(v)
          when Date     then v.to_time
          when NilClass then nil
          else
            raise UnsupportedError
          end
        end
      end
    end
  end
end

# rubocop:enable Metrics/CyclomaticComplexity
