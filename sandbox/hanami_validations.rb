require 'hanami'
require 'pry'
require 'pry-byebug'

class Foo
  include Hanami::Validations

  validations do
    required(:one) { size?(3) }
    required(:two) { hash? { size?(2..4) } }
    required(:three) { hash? { size?(2..4) { each { int? }} } }
    required(:four) { hash? { min_size?(3) } }
    required(:five) { hash? { max_size?(0) } }
    required(:six) { str? }
  end
end

class Bar
  include Hanami::Validations

  validations do
    required(:one) { format?(/ccc/) | format?(/ddd/) }
    # required(:two) { included_in?(['one']) }
    # required(:three) { included_in?(['one', [1], Time.now]) }
    # required(:four) { empty? }
    # required(:five) { empty? }
    # required(:six) { empty? }
  end
end

result = Bar.new(
  one: 'abb',
  two: :'',
  three: [],
  four: {},
  five: nil
).validate


binding.irb
