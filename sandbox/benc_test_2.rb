require_relative '../lib/attributable'
require 'virtus'
require 'benchmark/ips'
require 'pry'
require 'pry-byebug'

# Test 2: Normal object
# A user class where an integer and a float will need to be coerced from a string

class UserVirtus
  include Virtus.model
  attribute :first_name, String
  attribute :last_name,  String
  attribute :age,        Integer
  attribute :a_float,    Float
end

class UserAttributable
  extend Attributable
  attribute :first_name, String
  attribute :last_name,  String
  attribute :age,        Integer
  attribute :a_float,    Float
end

test_2_hash = {
  first_name: 'Test', last_name: 'Person', age: '1', a_float: '0.001'
}

Benchmark.ips do |x|
  x.report('Attributable Normal') {
    instance = UserAttributable.new(test_2_hash)
    instance.first_name == 'Test'
    instance.last_name == 'Person'
    instance.age == 1
    instance.a_float == 0.001
  }
  x.report('Virtus Normal') {
    instance = UserVirtus.new(test_2_hash)
    instance.first_name == 'Test'
    instance.last_name == 'Person'
    instance.age == 1
    instance.a_float == 0.001
  }
  x.compare!
end
