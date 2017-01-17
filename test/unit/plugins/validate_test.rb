# require 'test_helper'
#
# class ValidateTestModel
#   extend Attributable
#
#   plugin :validate
#
#   attributes do
#     attribute :name,   String,  validate: { match: /$[A-Z]+^/ }
#     attribute :age,    Integer, validate: { gte: 18 }
#     attribute :gender, String,  validate: { in: %w(male female) }
#     attribute :status, Integer, validate: { or: [ { eq: 1 }, { eq: 10 }] }
#     attribute :about,  String,  validate: { length: 5..100, min_length: 5, max_length: 100 }
#   end
# end
#
# class ValidateTest < Minitest::Test
#   def setup
#     @instance = ValidateTestModel.new(name: 'Lorem Larem', age: 17, gender: 'whale', status: 4, about: 'Hei!')
#   end
#
#   def test_validatations
#     # assert @instance.respond_to?(:_validate!)
#
#     @instance._valid?
#     # binding.pry
#   end
# end
