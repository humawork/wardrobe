# frozen_string_literal: true

module Wardrobe
  module Coercible
    module_function

    class UnsupportedError < StandardError; end

    def coerce(val, to:, parent: nil, atr: nil)
      coercer(val.class, to).call(val, to, parent, atr)
    end

    def add_coercer(hash, &blk)
      raise ArgumentError unless (from, to = hash.first)
      if to.respond_to?(:ancestors)
        coercers[to] ||= {}
        coercers[to][from] = blk
      else
        coercers[to.class] ||= {}
        coercers[to.class][:instance_of] ||={}
        coercers[to.class][:instance_of][from] = blk
      end
    end

    def coerce_lookup_cache
      @@coercer_lookup_cache ||= {}
    end

    def coercer(from, to)
      coerce_lookup_cache.dig(to, from) || find_coercer(from, to)
    end

    def find_coercer(from, to)
      to_hash = if to.respond_to?(:ancestors)
                  if res = to.ancestors.find { |k| coercers[k] }
                    coercers[res]
                  end
                elsif res = coercers.dig(to.class, :instance_of)
                  res
                end
      if to_hash && from_klass = from.ancestors.find { |klass| to_hash[klass] }
        coerce_lookup_cache[to] ||= {}
        coerce_lookup_cache[to][from] = to_hash[from_klass]
        return to_hash[from_klass]
      end
      raise UnsupportedError
    end

    def coercers
      @@coercers ||= Hash.new
    end
  end
end

require 'set'
require 'date'
require 'wardrobe/coercible/array'
require 'wardrobe/coercible/set'
require 'wardrobe/coercible/date'
require 'wardrobe/coercible/date_time'
require 'wardrobe/coercible/float'
require 'wardrobe/coercible/hash'
require 'wardrobe/coercible/integer'
require 'wardrobe/coercible/object'
require 'wardrobe/coercible/string'
require 'wardrobe/coercible/boolean'
require 'wardrobe/coercible/symbol'
require 'wardrobe/coercible/time'
require 'wardrobe/coercible/proc'
require 'wardrobe/coercible/open_struct'
require 'wardrobe/coercible/regexp'
require 'wardrobe/coercible/basic_object'
require 'wardrobe/coercible/wardrobe'
