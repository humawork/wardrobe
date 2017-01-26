require_relative '../lib/atrs'
require 'virtus'
require 'benchmark/ips'
require 'pry'
require 'pry-byebug'

# Test 1: Simple object
# Simple class with one attribute where input does not need coercion.

class SimpleVirtus
  include Virtus.model
  attribute :name, String
end

class SimpleAtrs
  extend Atrs
  attribute :name, String
end

Benchmark.ips do |x|
  x.report('Atrs Simple') {
    instance = SimpleAtrs.new(name: 'Test')
    instance.name == 'Test'
  }
  x.report('Virtus Simple') {
    instance = SimpleVirtus.new(name: 'Test')
    instance.name == 'Test'
  }
  x.compare!
end
