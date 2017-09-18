# frozen_string_literal: true

module Wardrobe
  module Coercible
    add_coercer(NilClass => Integer) { nil }
    add_coercer(Integer => Integer)  { |v| v }
    add_coercer(String => Integer)   { |v| v.to_i }
    add_coercer(Float => Integer)    { |v| v.to_i }
    add_coercer(Time => Integer)     { |v| v.to_i }
    add_coercer(Date => Integer)     { |v| v.to_time.to_i }
    add_coercer(DateTime => Integer) { |v| v.to_time.to_i }
  end
end
