# frozen_string_literal: true

module Wardrobe
  module Coercible
    add_coercer(NilClass => Wardrobe) do |_, klass, _, atr|
      atr&.options&.fetch(:init_if_nil, false) ? klass.new : nil
    end
    add_coercer(Wardrobe => Wardrobe) { |v| v }
    add_coercer(Hash => Wardrobe)     { |v, klass| klass.new(v) }
    add_coercer(Object => Wardrobe)   { |v, klass| klass.new(v) }
  end
end
