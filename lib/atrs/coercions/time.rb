# frozen_string_literal: true

require 'time'

module Atrs
  module Coercions
    refine Time.singleton_class do
      def coerce(v, _atr)
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
