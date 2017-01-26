require_relative 'atrs/version'
require_relative 'atrs/plugin'
require_relative 'atrs/coercions'
require_relative 'atrs/block_runner'
require_relative 'atrs/boolean'
require_relative 'atrs/attribute'
require_relative 'atrs/attribute_set'
require_relative 'atrs/class_methods'
require_relative 'atrs/instance_methods'
require_relative 'atrs/plugins/nil_if_empty'
require_relative 'atrs/plugins/nil_if_zero'
require_relative 'atrs/plugins/default_value'
require_relative 'atrs/plugins/preset'
require_relative 'atrs/plugins/present'
require_relative 'atrs/plugins/validations'
require_relative 'atrs/plugins/optional_setter'
require_relative 'atrs/plugins/optional_getter'

module Atrs
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
