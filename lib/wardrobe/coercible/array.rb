# frozen_string_literal: true
require_relative 'instance_coercer/array'

module Wardrobe
  module Coercible
    add_coercer(NilClass => Array) { |_, klass| klass.new }
    add_coercer(Array => Array)    { |v| v }
    add_coercer(Set => Array)      { |v| v.to_a }

    add_coercer(NilClass => []) do |v, klass, parent|
      InstanceCoercer::Array.init(klass.class.new, klass, parent)
    end

    add_coercer(Set => []) do |v, klass, parent|
      InstanceCoercer::Array.init(v, klass, parent)
    end

    add_coercer(Array => []) do |v, klass, parent|
      InstanceCoercer::Array.init(v, klass, parent)
    end
  end
end
