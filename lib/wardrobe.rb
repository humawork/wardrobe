# frozen_string_literal: true

require 'wardrobe/version'
require 'wardrobe/boolean'
require 'wardrobe/store'
require 'wardrobe/getter_setter'
require 'wardrobe/attribute'
require 'wardrobe/attribute_store'
require 'wardrobe/option'
require 'wardrobe/option_store'
require 'wardrobe/plugin'
require 'wardrobe/plugin_store'
require 'wardrobe/stores'
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
