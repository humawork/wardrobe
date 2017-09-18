# frozen_string_literal: true

module Wardrobe
  module Coercible
    add_coercer(Object => Object) do |v, klass|
      begin
        klass.new(v)
      rescue ArgumentError
        raise UnsupportedError
      end
    end
  end
end
