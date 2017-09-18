# frozen_string_literal: true

module Wardrobe
  module Coercible
    add_coercer(BasicObject => BasicObject) { |v| v }
  end
end
