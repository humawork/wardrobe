require 'test_helper'


class NilIfZeroTest < TestBase
  class Row
    include Wardrobe
    plugin :nil_if_zero

    attributes do
      nil_if_zero do
        attribute :test_in_block, Integer
      end
    end
    attribute :some_relation_id,       Integer, nil_if_zero: true
    attribute :some_other_relation_id, Integer, nil_if_zero: false
    attribute :string,                 String, nil_if_zero: true
    attribute :string_false,           String, nil_if_zero: false
  end

  def setup
    @row = Row.new(
      some_relation_id: 0,
      some_other_relation_id: 0,
      test_in_block: 0,
      string: '0',
      string_false: '0'
    )
  end

  def test_default_literal
    assert_nil @row.some_relation_id
    assert_equal 0, @row.some_other_relation_id
    assert_nil @row.test_in_block
    assert_nil @row.string
    assert_equal '0', @row.string_false
  end
end
