module Wardrobe
  module Plugins
    module Merge
      extend Wardrobe::Plugin

      module MergeRefinements
        refine Object do
          def merge(other)
            other.dup
          end
          def deep_merge(other)
            merge(other)
          end
        end
        refine Hash do
          def deep_merge(other)
            dup.tap do |h|
              other.each do |k,v|
                h[k] = h[k].deep_merge(v)
              end
            end
          end
        end
      end

      module InstanceMethods
        using MergeRefinements
        def merge(other, deep: false)
          raise TypeError, "Class missmatch #{other.class} != #{self.class}" unless other.class == self.class
          merge_type = deep ? :merge : :deep_merge
          res = _attribute_store.inject({}) do |hash, atr|
            hash[atr.name] = send(atr.name).send(merge_type, other.send(atr.name))
            hash
          end
          self.class.new(res)
        end

        def deep_merge(other)
          merge(other, deep: true)
        end
      end
    end
  end
  register_plugin(:merge, Plugins::Merge)
end
