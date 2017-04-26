# frozen_string_literal: true

module Atrs
  module Coercions
    refine DateTime.singleton_class do
      def coerce(v, atr)
        case v
        when self     then v
        when String   then DateTime.parse(v)
        when Date     then v.to_datetime
        when Time     then v.to_datetime
        when Integer  then Time.at(v).to_datetime
        when Float    then Time.at(v).to_datetime
        when NilClass then nil
        else
          raise UnsupportedError
        end
      end
    end
  end
end
