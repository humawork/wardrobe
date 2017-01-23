module Attributable
  module Coercions
    refine Object.singleton_class do
      def coerce(v, atr)
        # What should be default behaivor? Add option to use nil?
        self.new(v)
      rescue TypeError => e
        puts "Error: Can't coerce #{v || 'nil'} into #{self}"
        raise e
      end
    end
  end
end
