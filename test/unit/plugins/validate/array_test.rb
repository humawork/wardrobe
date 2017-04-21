# require 'test_helper'
#
# class ValidateTestArrayModel
#   include Atrs
#
#   plugin :validate
#
#   attributes do
#     attribute :names, Array[String]
#     # attribute :name,   String,  validate: { match: /$[A-Z]+^/ }
#     # attribute :age,    Integer, validate: { gte: 18 }
#     # attribute :gender, String,  validate: { in: %w(male female) }
#     # attribute :status, Integer, validate: { or: [ { eq: 1 }, { eq: 10 }] }
#     # attribute :about,  String,  validate: { length: 5..100, min_length: 5, max_length: 100 }
#   end
# end
#
# class ValidateArrayTest < Minitest::Test
#   def setup
#     @instance = ValidateTestArrayModel.new(names: [1,2,3])
#   end
#
#   def test_validatations
#     # assert @instance.respond_to?(:_validate!)
#
#     assert @instance._valid?
#   end
# end

# require 'test_helper'
# # required(:codes) { array? { min_size?(2) & each { str? } } }
#
# class ArrayValidationTest < Minitest::Test
#   class ArrayObject
#     include Atrs
#     plugin :validation
#     attribute :one, Array, validates: { and: [ { array?: true }, { min_size: 3 }, { each: { min_length: 3 }} ]}
#     # This can work!
#     # attribute :two, Array, validates { array? { each { str? & min_size?(3) } & min_size?(3) } }
#   end
#
#   def test_coercion
#     object = ArrayObject.new(
#       one: ['1234', 'ss']
#     )
#     assert_equal({
#       one: [
#         'size cannot be less than 3',
#         {1=>['length cannot be less than 3']}
#       ],
#       two: [
#         'size cannot be less than 3',
#         {1=>['length cannot be less than 3']}
#       ]
#     }, object._validation_errors)
#     refute object._valid?
#   end
# end

#<Dry::Validation::Result output={:name=>"Luca", :codes=>[1, "1"]} errors={:codes=>{0=>["must be a string"]}}>

#
# class Signup
#   include Hanami::Validations
#
#   validations do
#     required(:name) { filled? & str? & size?(3..64) }
#     required(:codes) { array? { each { str? & min_size?(2) } & min_size?(3) } }
#   end
# end
#
# result = Signup.new(name: "Luca", codes: ['12', '12']).validate
# result.success? # => true
