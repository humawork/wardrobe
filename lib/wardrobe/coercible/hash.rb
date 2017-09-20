# frozen_string_literal: true
require_relative 'instance_coercer/hash'

module Wardrobe
  module Coercible
    add_coercer(NilClass => Hash)  { Hash.new }
    add_coercer(Hash => Hash)  { |v| v }
    add_coercer(Array => Hash) { |v| Hash[*v] }
    add_coercer(Object => Hash) { |v| v.to_h }

    add_coercer(NilClass => {}) do |v, klass, parent|
      InstanceCoercer::Hash.init({}, klass, parent)
    end

    add_coercer(Array => {}) do |v, klass, parent|
      InstanceCoercer::Hash.init(Hash[*v], klass, parent)
    end

    add_coercer(Hash => {}) do |v, klass, parent|
      InstanceCoercer::Hash.init(v, klass, parent)
    end
  end
end
