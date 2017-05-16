# frozen_string_literal: true

module Wardrobe
  module Plugins
    module Validation
      module Refinements
        refine ::Array do

          alias_method :original_empty?, :empty?

          def empty?
            return if original_empty?
            'must be empty'
          end

          # include Empty
          include Size

          def filled?
            return unless original_empty?
            'must be filled'
          end

          # alias_method :original_each, :each
          def each?(predicates)
            errors = Hash.new do |h,k|
              h.merge!({ k => []}) unless h.key?(k)
              h.fetch(k)
            end
            predicates.each_pair do |k,v|
              each.with_index do |item, index|
                if res = item.send(k,v)
                  errors[index] << res
                end
              end
            end
            errors
          end
        end
      end
    end
  end
end
