require 'bench_helper'


class InitBenchTest < TestBase

  class Simple
    include Wardrobe
    attribute :foo, String
    attribute :bar, String
  end

  class Flex
    include Wardrobe
    plugin :flex_initializer
    attribute :foo, String
    attribute :bar, String
  end

  def test_init
    assert Simple.new(foo: 'a', bar: 'b').bar == 'b'
    assert Flex.new(foo: 'a', bar: 'b').bar == 'b'
    assert Flex.new({ 'foo' => 'a', 'bar' => 'b'}).bar == 'b'
    assert Flex.new({ 'foo' => 'a'}, bar: 'b').bar == 'b'
    report = Benchmark.ips do |x|
      x.report('simple') { Simple.new(foo: 'a', bar: 'b') }
      x.report('flex_key_args') { Flex.new(foo: 'a', bar: 'b') }
      x.report('flex_string_hash') { Flex.new({ 'foo' => 'a', 'bar' => 'b'}) }
      x.report('flex_mixed') { Flex.new({ 'foo' => 'a'}, bar: 'b') }
      x.compare!
    end

    data = report.data.map { |item| [item[:name].to_sym,item] }.to_h

    assert_equal 'simple', report.entries.max_by { |item| item.ips }.label
    assert (data[:simple][:ips] / data[:flex_mixed][:ips]) > 1.5
    assert (data[:simple][:ips] / data[:flex_string_hash][:ips]) > 1.5
    assert (data[:simple][:ips] / data[:flex_key_args][:ips]) > 1.2
  end
end
