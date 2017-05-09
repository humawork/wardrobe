require 'pry'
require 'pry-byebug'

$:.unshift File.expand_path('../../lib', __FILE__)
require_relative '../lib/wardrobe'
require 'virtus'
require 'benchmark/ips'

# Test 1: Simple object
# Simple class with one attribute where input does not need coercion.

VanillaStruct = Struct.new(:name)

class VanillaClass
  attr_reader :name

  def initialize(name:)
    @name = name
  end
end

class SimpleVirtus
  include Virtus.model
  attribute :name, String
end

class SimpleWardrobe
  include Wardrobe
  attribute :name, String
end

Benchmark.ips do |x|
  x.report('Vanilla Struct') {
    instance = VanillaStruct.new('Test')
    instance.name == 'Test'
  }
  x.report('Vanilla Class') {
    instance = VanillaClass.new(name: 'Test')
    instance.name == 'Test'
  }
  x.report('Wardrobe Simple') {
    instance = SimpleWardrobe.new(name: 'Test')
    instance.name == 'Test'
  }
  x.report('Virtus Simple') {
    instance = SimpleVirtus.new(name: 'Test')
    instance.name == 'Test'
  }
  x.compare!
end
