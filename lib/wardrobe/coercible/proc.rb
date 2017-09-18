# frozen_string_literal: true

module Wardrobe
  module Coercible
    add_coercer(NilClass => Proc) { nil }
    add_coercer(Proc => Proc)     { |v| v }
    #TODO:
    # refine Proc do
    #   def coerce(v, atr, parent)
    #     call(v, atr, parent)
    #   end
    # end
  end
end
