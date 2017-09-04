module Wardrobe
  module Plugins
    module Reset
      extend Wardrobe::Plugin


      module InstanceMethods
        def _reset
          initialize
        end

        def _reset!
          self.class.new
        end

        # using MergeRefinements
        # def merge(other, deep: false)
        #   raise TypeError, "Class missmatch #{other.class} != #{self.class}" unless other.class == self.class
        #   merge_type = deep ? :merge : :deep_merge
        #   res = _attribute_store.inject({}) do |hash, atr|
        #     hash[atr.name] = send(atr.name).send(merge_type, other.send(atr.name))
        #     hash
        #   end
        #   self.class.new(res)
        # end
        #
        # def deep_merge(other)
        #   merge(other, deep: true)
        # end
      end
    end
  end
  register_plugin(:reset, Plugins::Reset)
end
