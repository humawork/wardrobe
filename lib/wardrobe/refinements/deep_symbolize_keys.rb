module Wardrobe
  module Refinements
    module DeepSymbolizeKeys
      refine Object do
        def deep_symbolize_keys
          self
        end

        def deep_symbolize_keys!
          self
        end
      end
      refine Hash do
        def deep_symbolize_keys
          map do |k,v|
            [k.to_sym, v.deep_symbolize_keys]
          end.to_h
        end

        def deep_symbolize_keys!
          keys.each do |k|
            next if k.is_a?(Symbol)
            self[k.to_sym] = self.delete(k).deep_symbolize_keys!
          end
          self
        end
      end
      refine Array do
        def deep_symbolize_keys
          map(&:deep_symbolize_keys)
        end

        def deep_symbolize_keys!
          map!(&:deep_symbolize_keys!)
        end
      end
    end
  end
end
