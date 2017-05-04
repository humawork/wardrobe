# frozen_string_literal: true

require 'atrs/version'
require 'atrs/boolean'
require 'atrs/store'
require 'atrs/coercions'
require 'atrs/getter_setter'
require 'atrs/attribute'
require 'atrs/attribute_store'
require 'atrs/option'
require 'atrs/option_store'
require 'atrs/plugin'
require 'atrs/plugin_store'
require 'atrs/config'
require 'atrs/block_setup'
require 'atrs/class_methods'
require 'atrs/instance_methods'
require 'atrs/module_methods'

# Top level Atrs module
module Atrs
  extend ModuleMethods
end

require 'atrs/root_config'

# rubocop:disable Style/MethodName
def Atrs(**options)
  mod = Module.new do
    extend Atrs::ModuleMethods
  end
  mod.configure { |config| config.build(options) }
  mod
end
# rubocop:enable Style/MethodName
