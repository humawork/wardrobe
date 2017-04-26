# frozen_string_literal: true

module Atrs
  module Coercions
    refine Object.singleton_class do
      def coerce(v, _atr)
        # What should be default behaivor? Add option to use nil?
        new(v)
      rescue TypeError => e
        puts "Error: Can't coerce #{v || 'nil'} into #{self}"
        raise e
      end
    end
  end
end
