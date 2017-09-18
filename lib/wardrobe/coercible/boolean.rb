# frozen_string_literal: true

module Wardrobe
  module Coercible
    TRUE_STRINGS = Set.new(['1', 'yes', 'true']).freeze
    FALSE_STRINGS = Set.new(['0', 'no', 'false']).freeze

    add_coercer(NilClass => Boolean)   { nil }
    add_coercer(TrueClass => Boolean)  { |v| v }
    add_coercer(FalseClass => Boolean) { |v| v }
    add_coercer(Integer => Boolean) do |v|
      if v == 0
        false
      elsif v == 1
        true
      else
        raise UnsupportedError
      end
    end
    
    add_coercer(String => Boolean) do |v|
      if FALSE_STRINGS.include?(v)
        false
      elsif TRUE_STRINGS.include?(v)
        true
      else
        raise UnsupportedError
      end
    end
  end
end
