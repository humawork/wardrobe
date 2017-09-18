# frozen_string_literal: true

module Wardrobe
  module Coercible
    add_coercer(NilClass => Time) { nil }
    add_coercer(Time => Time)     { |v| v }
    add_coercer(String => Time)   { |v| Time.parse(v) }
    add_coercer(Integer => Time)  { |v| Time.at(v) }
    add_coercer(Float => Time)    { |v| Time.at(v) }
    add_coercer(Date => Time)     { |v| v.to_time }
    add_coercer(DateTime => Time) { |v| v.to_time }
  end
end
