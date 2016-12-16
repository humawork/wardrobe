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

module Attributable
  def self.extended(base)
    base.extend(ClassMethods)
    base.include(InstanceMethods)
  end
end
