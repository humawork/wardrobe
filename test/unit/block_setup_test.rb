require 'test_helper'

module OptionTestPlugin
  extend Wardrobe::Plugin
  option :symbol, Symbol
  option :string, String
  option :date, Date
  option :time, Time
  option :proc, Proc
end

Wardrobe.register_plugin(:option_test, OptionTestPlugin)

class BlockModel
  include Wardrobe
  plugin :nil_if_empty
  plugin :nil_if_zero
  plugin :test_plugin
  plugin :alias_setters
  plugin :validation

  attributes nil_if_empty: true, nil_if_zero: true, preset: :one, validates: { method: :int?, arguments: 1 }, alias_setter: :nested_int_alias do
    attribute :name,    String, preset: :two, validates: { method: :str?, arguments: 1 }
    attribute :status,  Integer
    attribute :friends, Array
    nil_if_empty false do
      attribute :address, String
      nil_if_zero false do
        attribute :id, Integer
        attribute :uuid, Integer, nil_if_zero: true
        nil_if_zero true do
          attributes nil_if_zero: false do
            attribute :nested_int, Integer, alias_setter: :nested_int_alias_2
          end
        end
      end
    end
  end
end

class BlockSetupTest < TestBase
  def test_one
    instance = BlockModel.new(name: '', status: 0, friends: [], address: '', id: 0, uuid: 0, nested_int: 0 )
    assert_nil instance.name
    assert_nil instance.status
    assert_nil instance.friends
    assert_equal '', instance.address
    assert_equal 0, instance.id
    assert_nil instance.uuid
    assert_equal 0, instance.nested_int
  end

  class OptionTypesTest
    include Wardrobe
    plugin :option_test
    attributes symbol: :test, string: 'test', date: Time.now.to_date, time: Time.now, proc: ->() {'proc'}  do
      attribute :foo, String
      attribute :bar, String
    end
  end

  def test_option_types
    OptionTypesTest.attribute_store.store.each do |_,atr|
      assert_equal :test, atr.options[:symbol]
      assert_equal 'test', atr.options[:string]
      assert_equal Date, atr.options[:date].class
      assert_equal Time, atr.options[:time].class
      assert_equal 'proc', atr.options[:proc].call
    end
  end

  def test_coercion
    klass = Class.new do
      include Wardrobe
      plugin :option_test
      attributes symbol: 'foo', string: :bar do
        attribute :name, String
      end
    end

    assert_equal :foo, klass.attribute_store[:name].options[:symbol]
    assert_equal 'bar', klass.attribute_store[:name].options[:string]
  end

  def test_crash
    assert_raises(Wardrobe::Plugins::Coercible::Refinements::UnsupportedError) do
      klass = Class.new do
        include Wardrobe
        plugin :option_test
        attributes proc: 'foo' do
          attribute :name, String
        end
      end
    end
    assert_equal 1, log_messages.length
  end
end
