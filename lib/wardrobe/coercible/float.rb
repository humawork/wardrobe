# frozen_string_literal: true

module Wardrobe
  module Coercible
    add_coercer(NilClass => Float) { nil }
    add_coercer(Float => Float)    { |v| v }
    add_coercer(Integer => Float)  { |v| v.to_f }
    add_coercer(String => Float)   { |v| v.to_f }
    add_coercer(Time => Float)     { |v| v.to_f }
    add_coercer(Date => Float)     { |v| v.to_time.to_f }
    add_coercer(DateTime => Float) { |v| v.to_time.to_f }
  end
end
