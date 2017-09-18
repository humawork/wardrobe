# frozen_string_literal: true

module Wardrobe
  module Coercible
    add_coercer(NilClass => Symbol) { nil }
    add_coercer(Symbol => Symbol)   { |v| v }
    add_coercer(String => Symbol)   { |v| v.to_sym }
  end
end
