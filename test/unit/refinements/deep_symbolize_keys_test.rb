# frozen_string_literal: true

require 'test_helper'

class RefinementsDeepSymbolizeKeysTest < TestBase
  using Wardrobe::Refinements::DeepSymbolizeKeys

  def test_hash_symbolize_keys
    hash = {
      'foo' => 1,
      'child' => {
        'bar' => [
          {
            'in' => 'array'
          }
        ]
      }
    }
    result = hash.deep_symbolize_keys
    assert result[:foo]
    assert result[:child]
    assert result[:child][:bar]
    assert result[:child][:bar][0][:in]
    refute_equal hash.object_id, result.object_id
    refute_equal hash['child'].object_id, result[:child].object_id
    refute_equal hash['child']['bar'].object_id, result[:child][:bar].object_id
    refute_equal hash['child']['bar'][0].object_id, result[:child][:bar][0].object_id
  end

  def test_hash_symbolize_keys!
    hash = {
      'foo' => 1,
      'child' => {
        'bar' => [
          {
            'in' => 'array'
          }
        ]
      }
    }
    result = hash.deep_symbolize_keys!
    assert result[:foo]
    assert result[:child]
    assert result[:child][:bar]
    assert result[:child][:bar][0][:in]
    assert_equal hash.object_id, result.object_id
    assert_equal hash[:child].object_id, result[:child].object_id
    assert_equal hash[:child][:bar].object_id, result[:child][:bar].object_id
    assert_equal hash[:child][:bar][0].object_id, result[:child][:bar][0].object_id
  end

  def test_array_symbolize_keys
    array = [
      {
        'foo' => 1
      },
      {
        'bar' => 2
      }
    ]
    result = array.deep_symbolize_keys
    assert_equal 1, result[0][:foo]
    assert_equal 2, result[1][:bar]
    refute_equal array.object_id, result.object_id
    refute_equal array[0].object_id, result[0].object_id
    refute_equal array[1].object_id, result[1].object_id
  end

  def test_array_symbolize_keys!
    array = [
      {
        'foo' => 1
      },
      {
        'bar' => 2
      }
    ]
    result = array.deep_symbolize_keys!
    assert_equal 1, result[0][:foo]
    assert_equal 2, result[1][:bar]
    assert_equal array.object_id, result.object_id
    assert_equal array[0].object_id, result[0].object_id
    assert_equal array[1].object_id, result[1].object_id
  end
end
