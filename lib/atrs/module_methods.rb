# frozen_string_literal: true

require 'logger'

module Atrs
  # This module is extended in Atrs and extended to anonymous modules created by
  # Atrs() method.
  module ModuleMethods
    def included(base)
      base.extend(ClassMethods)
      unless base.to_s == 'Atrs::RootConfig'
        base.root_config = config
        base.plugin(*config.default_plugins)
      end
      base.include(InstanceMethods)
    end

    def create_class(plugins: [], attributes: [])
      Class.new.class_exec do
        include Atrs
        plugin(*plugins)
        attributes.each do |atr|
          attribute(atr[:name], const_get(atr[:class]), atr.fetch(:options, {}))
        end
        self
      end
    end

    def config
      @config ||= begin
        callee = caller_locations.first
        if callee.label == 'config' && callee.lineno == (__LINE__ + 3)
          RootConfig.new
        else
          Atrs.config
        end
      end
    end

    def configure(&blk)
      @config = config.mutate(&blk)
    end

    def logger
      @logger ||= Logger.new(STDOUT)
    end
  end
end
