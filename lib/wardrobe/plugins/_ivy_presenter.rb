# # frozen_string_literal: true
#
# require_relative 'presenter/refinements'
# module Wardrobe
#   module Plugins
#     module IvyPresenter
#       extend Wardrobe::Plugin
#
#       plugin :presenter
#
#       option :preset, Set
#       option :source, Boolean
#
#       module InstanceMethods
#         def _ivy_present(**args)
#           attributes_hash = IvyPresenter.build_attributes_hash(_attribute_store, **args)
#           _present(attributes: attributes_hash)
#         end
#
#
#         # using Refinements
#         # def _present(wardrobe: nil)
#         #   result = {}
#         #   _attribute_store.store.each do |key, atr|
#         #     if wardrobe.nil? || (wardrobe && wardrobe.key?(key))
#         #       result[key] = send(atr.name)._present(wardrobe: (wardrobe[key] if wardrobe))
#         #     end
#         #   end
#         #   result
#         # end
#       end
#
#       def self.build_attributes_hash(set, preset: nil, source: nil)
#         result = {}
#         set.each do |key, atr|
#           next unless atr.options[:preset]&.include?(preset) || atr.options[:source] == source
#           result[key] = nil
#         end
#         result
#       end
#     end
#   end
#   register_plugin(:ivy_presenter, Plugins::IvyPresenter)
# end
