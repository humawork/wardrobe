require 'test_helper'

class ValidateTestArrayModel
  extend Attributable

  plugin :validate

  attributes do
    attribute :names, Array[String]
    # attribute :name,   String,  validate: { match: /$[A-Z]+^/ }
    # attribute :age,    Integer, validate: { gte: 18 }
    # attribute :gender, String,  validate: { in: %w(male female) }
    # attribute :status, Integer, validate: { or: [ { eq: 1 }, { eq: 10 }] }
    # attribute :about,  String,  validate: { length: 5..100, min_length: 5, max_length: 100 }
  end
end

class ValidateArrayTest < Minitest::Test
  def setup
    @instance = ValidateTestArrayModel.new(names: [1,2,3])
  end

  def test_validatations
    # assert @instance.respond_to?(:_validate!)

    binding.pry
    assert @instance._valid?
  end
end
