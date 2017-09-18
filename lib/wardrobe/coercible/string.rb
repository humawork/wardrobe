# frozen_string_literal: true

module Wardrobe
  module Coercible
    add_coercer(NilClass => String) { nil }
    add_coercer(String => String)   { |v| v }
    add_coercer(Integer => String)  { |v| v.to_s }
    add_coercer(Float => String)    { |v| v.to_s }
    add_coercer(Symbol => String)   { |v| v.to_s }
  end
end
