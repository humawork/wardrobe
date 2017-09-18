# frozen_string_literal: true

module Wardrobe
  module Coercible
    add_coercer(NilClass => DateTime) { nil }
    add_coercer(DateTime => DateTime) { |v| v }
    add_coercer(String => DateTime)   { |v| DateTime.parse(v) }
    add_coercer(Date => DateTime)     { |v| v.to_datetime }
    add_coercer(Time => DateTime)     { |v| v.to_datetime }
    add_coercer(Integer => DateTime)  { |v| Time.at(v).to_datetime }
    add_coercer(Float => DateTime)    { |v| Time.at(v).to_datetime }
  end
end
