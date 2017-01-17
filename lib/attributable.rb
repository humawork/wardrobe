require_relative 'attributable/version'
require_relative 'attributable/plugin'
require_relative 'attributable/coercions'
require_relative 'attributable/block_runner'
require_relative 'attributable/boolean'
require_relative 'attributable/attribute'
require_relative 'attributable/attribute_set'
require_relative 'attributable/class_methods'
require_relative 'attributable/instance_methods'
require_relative 'attributable/plugins/nil_if_empty'
require_relative 'attributable/plugins/nil_if_zero'
require_relative 'attributable/plugins/default_value'
require_relative 'attributable/plugins/preset'
require_relative 'attributable/plugins/present'
require_relative 'attributable/plugins/validate'
require_relative 'attributable/plugins/optional_setter'
require_relative 'attributable/plugins/optional_getter'

module Attributable
  def self.extended(base)
    base.extend(ClassMethods)
    base.include(InstanceMethods)
    load_deafult_plugins(base)
  end

  def self.load_deafult_plugins(base)
    base.plugin(:optional_setter)
    base.plugin(:optional_getter)
  end
end
