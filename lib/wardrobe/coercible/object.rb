# frozen_string_literal: true

module Wardrobe
  module Coercible
    add_coercer(Object => Object) do |v, klass|
      if v.is_a?(klass)
        v
      else
        begin
          klass.new(v)
        rescue ArgumentError
          raise UnsupportedError
        end
      end
    end
  end
end
