# frozen_string_literal: true

require_relative 'presenter/refinements'
module Wardrobe
  module Plugins
    module IvyPresenter
      extend Wardrobe::Plugin

      option :preset, Set
      option :source, Boolean

      module InstanceMethods
        def _ivy_present(**args)
          wardrobe_hash = IvyPresenter.build_wardrobe_hash(_attribute_store, **args)
          _present(wardrobe: wardrobe_hash)
        end


        # using Refinements
        # def _present(wardrobe: nil)
        #   result = {}
        #   _attribute_store.store.each do |key, atr|
        #     if wardrobe.nil? || (wardrobe && wardrobe.key?(key))
        #       result[key] = send(atr.name)._present(wardrobe: (wardrobe[key] if wardrobe))
        #     end
        #   end
        #   result
        # end
      end

      def self.build_wardrobe_hash(set, preset: nil, source: nil)
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
