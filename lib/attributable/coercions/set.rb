module Attributable
  module Coercions
    refine Set.singleton_class do
      # def coerce(v)
      #   case v
      #   when self then v
      #   when Integer, Float
      #     v.to_s
      #   end
      # end
    end
  end
end
