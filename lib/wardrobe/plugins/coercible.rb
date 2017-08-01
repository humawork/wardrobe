# frozen_string_literal: true
require 'wardrobe/plugins/coercible/refinements/unsupported_error'
require 'wardrobe/plugins/coercible/refinements/array'
require 'wardrobe/plugins/coercible/refinements/set'
require 'wardrobe/plugins/coercible/refinements/date'
require 'wardrobe/plugins/coercible/refinements/date_time'
require 'wardrobe/plugins/coercible/refinements/float'
require 'wardrobe/plugins/coercible/refinements/hash'
require 'wardrobe/plugins/coercible/refinements/integer'
require 'wardrobe/plugins/coercible/refinements/object'
require 'wardrobe/plugins/coercible/refinements/string'
require 'wardrobe/plugins/coercible/refinements/boolean'
require 'wardrobe/plugins/coercible/refinements/symbol'
require 'wardrobe/plugins/coercible/refinements/time'
require 'wardrobe/plugins/coercible/refinements/proc'
require 'wardrobe/plugins/coercible/refinements/open_struct'

module Wardrobe
  class Attribute
    using Plugins::Coercible::Refinements

    def coerce(val)
      klass.coerce(val, self)
    rescue Plugins::Coercible::Refinements::UnsupportedError => e
      raise e.class,
            "Can't coerce #{val.class} `#{val}` into #{klass}."
    end
  end

  register_setter(
    name: :coercer,
    before: [:setter],
    use_if: ->(atr) { atr.options[:coerce] },
    setter: lambda do |value, atr, _instance, _options|
      atr.coerce(value)
    end
  )

  module Plugins
    module Coercible
      extend Wardrobe::Plugin
      option :coerce, Boolean, default: true, setter: :coercer

      module ClassMethods
        def coerce(val, _atr)
          return new if val.nil?
          return new(**val) if val.is_a?(Hash)
          return val if val.class == self
          new(val)
        end
      end
    end
  end
  register_plugin(:coercible, Plugins::Coercible)
end
