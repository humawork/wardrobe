# frozen_string_literal: true

require 'atrs/version'
require 'atrs/boolean'
require 'atrs/store'
require 'atrs/coercions'
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
require 'atrs/root_config'

require 'atrs/plugins/immutable'
require 'atrs/plugins/alias_setters'
require 'atrs/plugins/configurable'
require 'atrs/plugins/default'
require 'atrs/plugins/dirty_tracker'
require 'atrs/plugins/nil_if_empty'
require 'atrs/plugins/nil_if_zero'
require 'atrs/plugins/presenter'
require 'atrs/plugins/validation'
require 'atrs/plugins/optional_setter'
require 'atrs/plugins/optional_getter'
require 'atrs/plugins/ivy_presenter'

module Atrs
  def self.included(base)
    base.extend(ClassMethods)
    base.include(InstanceMethods)
    base.plugin(*config.default_plugins)
  end

  def self.config
    @config ||= RootConfig.new
  end

  def self.configure
    yield config
  end

  def self.create_class(plugins: [], attributes: [])
    Class.new.class_exec do
      include Atrs
      plugin(*plugins)
      attributes.each do |atr|
        attribute(atr[:name], const_get(atr[:class]), atr.fetch(:options, {}))
      end
      self
    end
  end
end
