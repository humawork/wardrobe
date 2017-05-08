# frozen_string_literal: true
require 'atrs/plugins/coercible/refinements/unsupported_error'
require 'atrs/plugins/coercible/refinements/array'
require 'atrs/plugins/coercible/refinements/set'
require 'atrs/plugins/coercible/refinements/date'
require 'atrs/plugins/coercible/refinements/date_time'
require 'atrs/plugins/coercible/refinements/float'
require 'atrs/plugins/coercible/refinements/hash'
require 'atrs/plugins/coercible/refinements/integer'
require 'atrs/plugins/coercible/refinements/object'
require 'atrs/plugins/coercible/refinements/string'
require 'atrs/plugins/coercible/refinements/boolean'
require 'atrs/plugins/coercible/refinements/symbol'
require 'atrs/plugins/coercible/refinements/time'

module Atrs
  class Attribute
    using Plugins::Coercible::Refinements

    def coerce(val)
      klass.coerce(val, self)
    rescue Plugins::Coercible::Refinements::UnsupportedError => e
      raise e.class,
            "Can't coerce #{val.class} `#{val}` into #{klass}"
    end
  end

  register_setter(
    name: :coercer,
    priority: -100,
    use_if: ->(_atr) { true },
    setter: lambda do |value, atr, _instance|
      atr.coerce(value)
    end
  )

  module Plugins
    module Coercible
      extend Atrs::Plugin
      option :coerce, Boolean, default: true, setter: :coercer

      module ClassMethods
        def coerce(val, _atr)
          return new if val.nil?
          return new(**val) if val.is_a?(Hash)
          new(val)
        end
      end
    end
  end
  register_plugin(:coercible, Plugins::Coercible)
end
