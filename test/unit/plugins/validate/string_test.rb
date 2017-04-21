require 'test_helper'
class StringValidationTest < Minitest::Test
  class StringObject
    include Atrs
    plugin :validation
    # This can work!
    # attribute :one, Array, validates { array? }
    attribute :name, String, validates: { min_length: 3 }
    attribute :zip_code, String, validates: { match: /[0-9]{5}/ }
    attribute :admin, Atrs::Boolean, validates: {
      if: {
        check: { eq: true },
        true => ->(one, two) { binding.pry }
      }
    }
  end

  def test_coercion
    object = StringObject.new(
      name: 'Te',
      zip_code: '1234',
      admin: true
    )

    assert_equal(
      {
        name: ["length cannot be less than 3"],
        zip_code: ["\"1234\" does not match regex '/[0-9]{5}/'"]
      },
      object._validation_errors
    )
    refute object._valid?
  end
end

 # => #<Dry::Validation::Result output={:name=>"Te", :zip_code=>"1234"} errors={:name=>["size cannot be less than 3"], :zip_code=>["is in invalid format"]}>


#<Dry::Validation::Result output={:name=>"Luca", :codes=>[1, "1"]} errors={:codes=>{0=>["must be a string"]}}>

# require 'hanami'
#
# class Signup
#   include Hanami::Validations
#
#   validations do
#     required(:name) { min_size?(3) }
#     required(:zip_code) { format?(/[0-9]{5}/) }
#   end
# end
#
# result = Signup.new(name: "Te", zip_code: "1234").validate
# result.success? # => true
