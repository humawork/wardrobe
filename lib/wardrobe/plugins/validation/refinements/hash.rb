# frozen_string_literal: true

module Wardrobe
  module Plugins
    module Validation
      module Refinements
        refine ::Hash do
          include Size

          alias_method :original_empty?, :empty?

          def empty?
            return if original_empty?
            'must be empty'
          end
          # include Empty

          alias_method :old_each_key, :each_key

          def filled?
            return unless original_empty?
            'must be filled'
          end

          def each_value(predicates)
            errors = Hash.new do |h, k|
              h.merge!({ k => {}}) unless h.key?(k)
              h.fetch(k)
            end
            predicates.each_pair do |method, check_value|
              each_pair do |key, value|
                if res = value.send(method, check_value)
                  errors[key][:key] ||= []
                  errors[key][:key] << res
                end
              end
            end
            errors
          end

          def each_key(predicates)
            errors = Hash.new do |h, k|
              h.merge!({ k => {}}) unless h.key?(k)
              h.fetch(k)
            end
            predicates.each_pair do |method, value|
              old_each_key do |key|
                if res = key.send(method,value)
                  errors[key][:value] ||= []
                  errors[key][:value] << res
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
