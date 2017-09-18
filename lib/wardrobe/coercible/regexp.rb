# frozen_string_literal: true

module Wardrobe
  module Coercible
    add_coercer(NilClass => Regexp) { nil }
    add_coercer(Regexp => Regexp)   { |v| v }
    add_coercer(String => Regexp)  do |v|
      if (md = v.match(/\/(.+)\/([a-z^\/]*)$/))
        options = 0
        options += 1 if md[2].include?('i')
        options += 2 if md[2].include?('x')
        options += 4 if md[2].include?('m')
        options += 16 if md[2].include?('u')
        Regexp.new(md[1], options)
      else
        raise UnsupportedError, "Unable to convert `#{v}` into Regexp"
      end
    end
  end
end
