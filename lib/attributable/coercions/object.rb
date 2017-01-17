module Attributable
  module Coercions
    refine Object.singleton_class do
      def coerce(v)
        # What should be default behaivor? Add option to use nil?
        self.new(v)
      end
    end
  end
end
