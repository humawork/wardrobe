require 'test_helper'

class Row
  extend Atrs
  attributes do
    nil_if_zero do
      attribute :test_in_block, Integer
    end
  end
  attribute :some_relation_id,       Integer, nil_if_zero: true
  attribute :some_other_relation_id, Integer, nil_if_zero: false
end

class NilIfZeroTest < Minitest::Test
  def setup
    @row = Row.new(some_relation_id: 0, some_other_relation_id: 0, test_in_block: 0)
  end

  def test_default_literal
    assert_nil @row.some_relation_id
    assert_equal 0, @row.some_other_relation_id
    assert_nil @row.test_in_block
  end
end
