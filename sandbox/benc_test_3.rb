require_relative '../lib/attributable'
require 'virtus'
require 'benchmark/ips'
require 'pry'
require 'pry-byebug'

# Test 3: Advanced object
# As in test 2 but with an address that needs to be coerced into a sub class.

class AddressVirtus
  include Virtus.model
  attribute :street, String
  attribute :zip_code, String
end

class UserAdvancedVirtus
  include Virtus.model
  attribute :first_name,           String
  attribute :last_name,            String
  attribute :age,                  Integer
  attribute :a_float,              Float
  attribute :with_default_literal, String, default: 'literal'
  attribute :with_default_proc,    String, default: ->(_,_) {'proc'}
  attribute :with_default_method,  String, default: :default_method
  attribute :address,              AddressVirtus

  def default_method
    'method'
  end
end

class AddressAttributable
  extend Attributable
  attribute :street, String
  attribute :zip_code, String
end

class UserAdvancedAttributable
  extend Attributable
  attribute :first_name,           String
  attribute :last_name,            String
  attribute :age,                  Integer
  attribute :a_float,              Float
  attribute :with_default_literal, String, default: 'literal'
  attribute :with_default_proc,    String, default: -> { 'proc' }
  attribute :with_default_method,  String, default: :default_method
  attribute :address,              AddressAttributable

  def default_method
    'method'
  end
end

test_3_hash = {
  first_name: 'Test', last_name: 'Person', age: '1', a_float: '0.001',
  address: {
    street: 'Somewhere In Japan',
    zip_code: 12345
  }
}


Benchmark.ips do |x|
  x.report('Attributable Advanced') {
    instance = UserAdvancedAttributable.new(test_3_hash)
    instance.first_name == 'Test'
    instance.last_name == 'Person'
    instance.age == 1
    instance.a_float == 0.001
    instance.with_default_literal == 'literal'
    instance.with_default_proc == 'proc'
    instance.with_default_method == 'method'
    instance.address.street == 'Somewhere In Japan'
    instance.address.zip_code == 12345
  }
  x.report('Virtus Advanced') {
    instance = UserAdvancedVirtus.new(test_3_hash)
    instance.first_name == 'Test'
    instance.last_name == 'Person'
    instance.age == 1
    instance.a_float == 0.001
    instance.with_default_literal == 'literal'
    instance.with_default_proc == 'proc'
    instance.with_default_method == 'method'
    instance.address.street == 'Somewhere In Japan'
    instance.address.zip_code == 12345
  }
  x.compare!
end
