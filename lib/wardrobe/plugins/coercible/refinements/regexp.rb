# frozen_string_literal: true

module Wardrobe
  module Plugins
    module Coercible
      module Refinements
        refine Regexp.singleton_class do
          def coerce(v, _atr, _parent)
            case v
            when self then v
            when String
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
            when NilClass then nil
            else
              raise UnsupportedError
            end
          end
        end
      end
    end
  end
end
