$:.unshift File.expand_path('../../lib', __FILE__)
class AlmostArray < Array

end
module Wardrobe
  module Coercions
    refine AlmostArray.singleton_class do
      def coerce(v, atr)
        case v
        when AlmostArray, Array then AlmostArray.new(v)
        when Set      then AlmostArray.new(v.to_a)
        when NilClass then []
        else
          raise UnsupportedError
        end
      end
    end

    refine AlmostArray do
      class WrongNumberOfItemsError < StandardError; end
      def coerce(v, atr)
        result = case v
        when Array, AlmostArray

          # This check shold be moved to attribute creation time
          raise StandardError, "`Array#{map(&:name)}' contains two many classes. No more than one is allowed." if count != 1
          v.map! { |item| first.coerce(item, nil) }
        when NilClass then AlmostArray.new
        else
          raise UnsupportedError
        end
      end
    end
  end
end

require 'wardrobe'
require 'benchmark/ips'
require 'pry'
require 'pry-byebug'
require 'ostruct'








class Embedded
  include Wardrobe
  attribute :name, String
end

class One
  include Wardrobe
  attribute :array, Array[Embedded]
end

class Two
  include Wardrobe
  attribute :array, AlmostArray[Embedded]
end

one = One.new
two = Two.new
# one.array.unshift({name: 'asf'})
# two.array.unshift({name: 'asf'})

# binding.pry


Benchmark.ips do |x|
  x.report('With Array Coercion') {
    one.array << { name: 'abcd' }
  }
  x.report('Without Array Coercion') {
    two.array << { name: 'abcd' }
  }
  # x.report('Modules') {
  #   modules.inject('') do |val, item|
  #     item.call(val, instance)
  #   end
  # }
  # x.report('Classes') {
  #   classes.inject('') do |val, item|
  #     item.new.call(val, instance)
  #   end
  # }
  x.compare!
end
