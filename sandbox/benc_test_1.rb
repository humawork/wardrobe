require_relative '../lib/atrs'
require 'virtus'
require 'benchmark/ips'
require 'pry'
require 'pry-byebug'

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

class SimpleAtrs
  extend Atrs
  attribute :name, String
end

binding.pry

Benchmark.ips do |x|
  x.report('Vanilla Struct') {
    instance = VanillaStruct.new('Test')
    instance.name == 'Test'
  }
  x.report('Vanilla Class') {
    instance = VanillaClass.new(name: 'Test')
    instance.name == 'Test'
  }
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
