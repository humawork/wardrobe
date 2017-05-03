require 'benchmark/ips'
require 'pry'
require 'pry-byebug'
require 'ostruct'
require 'middleware'

### One - Custom middleware System

class One
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

class Split < One
  def call(value)
    super(value.split(''))
  end
end

class EachDowncase < One
  def call(value)
    super(value.map(&:downcase))
  end
end

class EachAddSpace < One
  def call(value)
    super(value.map { |item| item + ' ' })
  end
end

one_stack = One.build(Split, EachDowncase, EachAddSpace)


#### Two - CUSTOM MIDDLEWARE SYSTEM WITH DYNAMIC CALL

module Some
  def call(input)
    return input unless next_middleware
    next_middleware.call(input)
  end
end


class Two
  attr_reader :middlewares
  def initialize(middlewares = arr)
    @middlewares = middlewares
    freeze
  end

  def call(input)
    middlewares.inject(input) do |val, pro|
      pro.call(val)
    end
  end

  def self.build(*arr)
    new(arr)
  end
end

split_2 = ->(value) {
  value.split('')
}

each_downcase_2 = ->(value) {
  value.map(&:downcase)
}

each_add_space_2 = ->(value) {
  value.map { |item| item + ' ' }
}

two_stack = Two.build(split_2, each_downcase_2, each_add_space_2)

CORRECT = ['a ', 'b ', 'c ', 'd ', 'e ', 'f ']


Benchmark.ips do |x|
  x.report('One - Custom') {
    result = one_stack.call('abcdef')
    # raise "ERROR" unless result == CORRECT
  }

  x.report('Two - Array of procs with inject') {
    result = two_stack.call('abcdef')
    # raise "ERROR" unless result == CORRECT
  }

  # x.report('Procs') {
  #   procs.inject('') do |val, item|
  #     item.call(val, instance)
  #   end
  # }
  # x.report('Lambdas') {
  #   lambdas.inject('') do |val, item|
  #     item.call(val, instance)
  #   end
  # }
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
  # x.report('Middleware Gem') {
  #   mid.call({val: '', instance: instance})[:val]
  # }
  x.compare!
end
