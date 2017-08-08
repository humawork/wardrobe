# frozen_string_literal: true

module Wardrobe
  module Plugins
    module AliasSetters
      extend Wardrobe::Plugin

      option :alias_setter, Array

      module ClassMethods
        def define_setter(atr)
          super
          atr.options[:alias_setter]&.each do |alias_setter|
            alias_method "#{alias_setter}=", atr.setter_name
          end
        end
      end

      module InstanceMethods
        private

        def _attribute_init(atr, hash, name)
          return super unless atr.options[:alias_setter]
          return super if atr.options[:alias_setter].empty?
          keys_in_hash = atr.options[:alias_setter].select { |key| hash.key?(key) }
          return super unless keys_in_hash.any?
          keys_in_hash.reverse.each do |key|
            send("#{name}=", atr.coerce(hash[key], self))
          end
        end
      end
    end
  end
  register_plugin(:alias_setters, Plugins::AliasSetters)
end
