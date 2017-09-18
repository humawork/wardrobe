# frozen_string_literal: true

module Wardrobe
  module Coercible
    add_coercer(NilClass => Wardrobe) { |v, klass| klass.new }
    add_coercer(Wardrobe => Wardrobe) { |v| v }
    add_coercer(Hash => Wardrobe)     { |v, klass| klass.new(v) }
    add_coercer(Object => Wardrobe)   { |v, klass| klass.new(v) }
  end
end
