module Atrs
  module Plugins
    module Validation
      module Refinements
        refine Array do
          alias_method :orig_each, :each



          def each(some)
            other_each(some)
            # puts some
            # some
            # binding.pry
            # some
          end

          def other_each(some)
            errors = Hash.new do |h,k|
              h.merge!({ k => []}) unless h.key?(k)
              h.fetch(k)
            end
            some.each_pair do |k,v|
              orig_each.each.with_index do |item, index|
                if res = item.send(k,v)
                  errors[index] << res
                end
              end
            end
            errors
          end

          def min_size(int)
            return if int < length
            "size cannot be less than #{int}"
          end

          # def gte(int)
          #   self >= int ? [true, nil] : [false, "integer #{self} violates greater than or equal to #{int}" ]
          # end
          #
          # def gt(int)
          #   return self > int, "Error"
          # end
          #
          # def eq(int)
          #   self == int ? [true, nil] : [false, "#{self} violates equality with #{int}"]
          # end
        end
      end
    end
  end
end
