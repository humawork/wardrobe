require_relative '../lib/attributable'
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

class SimpleAttributable
  extend Attributable
  attribute :name, String
end

Benchmark.ips do |x|
  x.report('Attributable Simple') {
    instance = SimpleAttributable.new(name: 'Test')
    instance.name == 'Test'
  }
  x.report('Virtus Simple') {
    instance = SimpleVirtus.new(name: 'Test')
    instance.name == 'Test'
  }
  x.compare!
end
