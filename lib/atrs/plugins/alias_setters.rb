# frozen_string_literal: true

module Atrs
  module Plugins
    module AliasSetters
      extend Atrs::Plugin

      option :alias_setter, Array

      module ClassMethods
        def define_setter(atr)
          super
          atr.alias_setter.each do |alias_setter|
            alias_method "#{alias_setter}=", atr.setter_name
          end
        end
      end

      module InstanceMethods
        private
        
        def _attribute_init(atr, hash, name)
          return super if atr.alias_setter.empty?
          keys_in_hash = atr.alias_setter.select { |key| hash.key?(key) }
          return super unless keys_in_hash.any?
          keys_in_hash.reverse.each do |key|
            send("#{name}=", atr.coerce(hash[key]))
          end
        end
      end
    end
  end
  register_plugin(:alias_setters, Plugins::AliasSetters)
end
