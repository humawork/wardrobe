# frozen_string_literal: true
require 'atrs/plugins/coercible/coercions/unsupported_error'
require 'atrs/plugins/coercible/coercions/array'
require 'atrs/plugins/coercible/coercions/set'
require 'atrs/plugins/coercible/coercions/date'
require 'atrs/plugins/coercible/coercions/date_time'
require 'atrs/plugins/coercible/coercions/float'
require 'atrs/plugins/coercible/coercions/hash'
require 'atrs/plugins/coercible/coercions/integer'
require 'atrs/plugins/coercible/coercions/object'
require 'atrs/plugins/coercible/coercions/string'
require 'atrs/plugins/coercible/coercions/boolean'
require 'atrs/plugins/coercible/coercions/symbol'
require 'atrs/plugins/coercible/coercions/time'

module Atrs
  class Attribute
    using Plugins::Coercible::Coercions

    def coerce(val)
      klass.coerce(val, self)
    rescue Plugins::Coercible::Coercions::UnsupportedError
      raise Plugins::Coercible::Coercions::UnsupportedError,
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
          new(**val)
        end
      end
    end
  end
  register_plugin(:coercible, Plugins::Coercible)
end
