require 'pry'
require 'pry-byebug'

class Middleware
  attr_reader :next_middleware
  def initialize(next_middleware = nil)
    @next_middleware = next_middleware
    freeze
  end

  def call(input)
    return input unless next_middleware
    next_middleware.call(input)
  end

  def self.build(*arr)
    arr.reverse!
    arr.inject(arr.shift.new) do |previous, current|
      current.new(previous)
    end
  end
end

class Split < Middleware
  def call(value)
    super(value.split(''))
  end
end

class EachDowncase < Middleware
  def call(value)
    super(value.map(&:downcase))
  end
end

class EachAddSpace < Middleware
  def call(value)
    super(value.map { |item| item + ' ' })
  end
end

stack = Middleware.build(Split, EachDowncase, EachAddSpace)
stack.call('abc')
binding.pry

# module Split
#   def self.call(input, instance)
#     result = input.split('')
#     if block_given?
#       yield result, instance
#     else
#       result
#     end
#   end
# end
#
# module EachDowncase
#   def self.call(input, instance)
#     result = input.each(&:downcase)
#     if block_given?
#       yield result, instance
#     else
#       result
#     end
#   end
# end

array = [
  Split,
  EachDowncase
]

val = 'abcde'

stack =


# arr = [
#   a_proc,
#   a_proc,
#   a_proc
# ].each do
#
# loop do
#   begin
#     current = arr.next
#     next_ = arr.peek
#     binding.pry
#
#   rescue StopIteration => e
#     binding.pry
#   end
# end

# arr.inject(->(_,_){ input }).to_enum.each do |item|
# end



first_proc.call('', &another_proc)

proc_enum = procs.to_enum

proc_enum

proc_enum.inject(nil) do |value, pr|

  binding.pry
end



# procs.each do |proc|
#   binding.pry
# end
#






class SomeClass
  proc2 = -> (one, two, &blk) {
    one + two
  }

  define_method(:name, &proc2)

  # end
end

ddd = SomeClass.new
ddd

binding.pry
ddd

1
