require_relative 'atrs/version'
require_relative 'atrs/plugin'
require_relative 'atrs/boolean'
require_relative 'atrs/coercions'
require_relative 'atrs/block_setup'
require_relative 'atrs/attribute'
require_relative 'atrs/attribute_set'
require_relative 'atrs/option'
require_relative 'atrs/option_set'
require_relative 'atrs/plugin_set'
require_relative 'atrs/class_methods'
require_relative 'atrs/instance_methods'
require_relative 'atrs/module_methods'
require_relative 'atrs/plugins/nil_if_empty'
require_relative 'atrs/plugins/nil_if_zero'
require_relative 'atrs/plugins/default'
require_relative 'atrs/plugins/presenter'
require_relative 'atrs/plugins/validations'
require_relative 'atrs/plugins/optional_setter'
require_relative 'atrs/plugins/optional_getter'
require_relative 'atrs/plugins/dirty_tracker'
require_relative 'atrs/plugins/alias_setters'

module Atrs
  attr_reader :attribute_set, :plugin_set, :option_set

  def self.extended(base)
    base.instance_variable_set(:@attribute_set, AttributeSet.new)
    base.instance_variable_set(:@plugin_set, PluginSet.new)
    base.instance_variable_set(:@option_set, OptionSet.new)
    case base
    when Class
      base.extend(ClassMethods)
      base.include(InstanceMethods)
    when Module
      base.extend(ModuleMethods)
    end
  end

  def plugin(*plugin_names)
    plugin_names.each { |name| enable_plugin(name) }
  end

  def enable_plugin(name)
    @plugin_set = plugin_set.add(name)
    enable_plugin_options(*@plugin_set[name].options)
  end

  def enable_plugin_options(*options)
    options.each do |option|
      @option_set = option_set.add(option.name, option)
    end
  end


  # load_deafult_plugins(base)
  # def self.load_deafult_plugins(base)
  #   base.plugin(:optional_setter)
  #   base.plugin(:optional_getter)
  # end
end
