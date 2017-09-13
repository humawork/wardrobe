# frozen_string_literal: true

require 'wardrobe/version'
require 'wardrobe/boolean'
require 'wardrobe/store'

require 'wardrobe/refinements/deep_symbolize_keys'

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
require 'wardrobe/plugins/coercible/refinements/regexp'
require 'wardrobe/plugins/coercible/refinements/basic_object'


require 'wardrobe/middleware_registry'
require 'wardrobe/middleware'
require 'wardrobe/getter'
require 'wardrobe/setter'
require 'wardrobe/attribute'
require 'wardrobe/attribute_store'
require 'wardrobe/option'
require 'wardrobe/option_store'
require 'wardrobe/plugin'
require 'wardrobe/plugin_store'
require 'wardrobe/config'
require 'wardrobe/block_setup'
require 'wardrobe/class_methods'
require 'wardrobe/instance_methods'
require 'wardrobe/module_methods'

# Top level Wardrobe module
module Wardrobe
  extend ModuleMethods
end

require 'wardrobe/root_config'

# rubocop:disable Style/MethodName
def Wardrobe(**options)
  mod = Module.new do
    extend Wardrobe::ModuleMethods
  end
  mod.configure { |config| config.build(options) }
  mod
end
# rubocop:enable Style/MethodName
