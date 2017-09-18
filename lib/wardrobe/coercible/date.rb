# frozen_string_literal: true

module Wardrobe
  module Coercible
    add_coercer(NilClass => Date) { nil }
    add_coercer(Date => Date)     { |v| v }
    add_coercer(String => Date)   { |v| Date.parse(v) }
    add_coercer(Time => Date)     { |v| v.to_date }
    add_coercer(DateTime => Date) { |v| v.to_date }
    add_coercer(Integer => Date)  { |v| Time.at(v).to_date }
    add_coercer(Float => Date)    { |v| Time.at(v).to_date }
  end
end
