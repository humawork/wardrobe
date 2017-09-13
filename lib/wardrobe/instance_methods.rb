# frozen_string_literal: true

module Wardrobe
  module InstanceMethods
    def initialize(**hash)
      _initialize { _wardrobe_init(hash) }
    end

    def _initializing?
      instance_variable_defined?(:@_initializing) && @_initializing
    end

    def _attribute_store
      _wardrobe_config.attribute_store
    end

    def _plugin_store
      _wardrobe_config.plugin_store
    end

    def _wardrobe_config
      if _singleton_initialized?
        singleton_class.wardrobe_config
      else
        self.class.wardrobe_config
      end
    end

    def _init_singleton!
      return if singleton_class.instance_variable_defined?(:@wardrobe_config)
      parent_stores = self.class.wardrobe_config
      singleton_class.instance_exec do
        extend Wardrobe::ClassMethods
        merge_wardrobe_config(parent_stores)
      end
      @_singleton_initialized = true
    end

    def _add_attribute(name, klass, **args, &blk)
      _init_singleton!
      singleton_class.attribute(name, klass, **args, &blk)
    end

    def _set_attribute_value(atr, value)
      instance_variable_set(atr.ivar_name, value)
    end

    def _get_attribute_value(atr)
      atr = _attribute_store[atr] if atr.is_a? Symbol
      instance_variable_get(atr.ivar_name)
    end

    private

    def _initialize
      instance_variable_set(:@_initializing, true)
      yield
      remove_instance_variable(:@_initializing)
    end

    def _singleton_initialized?
      @_singleton_initialized if instance_variable_defined?('@_singleton_initialized')
    end

    def _wardrobe_init(data)
      # Should we also loop over the hash and report on missing or additional attributes?
      _attribute_store.each do |atr|
        _attribute_init(atr, data)
      end
    end

    def _attribute_init(atr, hash)
      send(atr.setter_name, hash[atr.name])
    end
  end
end
