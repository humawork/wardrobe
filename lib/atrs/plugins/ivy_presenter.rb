require_relative 'presenter/refinements'
module Atrs
  module Plugins
    module IvyPresenter
      extend Atrs::Plugin

      option :preset, Set
      option :source, Boolean

      module InstanceMethods
        def _ivy_present(**args)
          atrs_hash = IvyPresenter.build_atrs_hash(_attribute_store, **args)
          _present(atrs: atrs_hash)
        end


        # using Refinements
        # def _present(atrs: nil)
        #   result = {}
        #   _attribute_store.store.each do |key, atr|
        #     if atrs.nil? || (atrs && atrs.key?(key))
        #       result[key] = send(atr.name)._present(atrs: (atrs[key] if atrs))
        #     end
        #   end
        #   result
        # end
      end

      def self.build_atrs_hash(set, preset: nil, source: nil)
        result = {}
        set.each do |key, atr|
          next unless atr.options[:preset]&.include?(preset) || atr.options[:source] == source
          result[key] = nil
        end
        result
      end
    end
  end
  register_plugin(:ivy_presenter, Plugins::IvyPresenter)
end
