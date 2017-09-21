# frozen_string_literal: true
require_relative 'instance_coercer/hash'

module Wardrobe
  module Coercible
    add_coercer(NilClass => Hash)  { Hash.new }
    add_coercer(Hash => Hash)  { |v| v }
    add_coercer(Array => Hash) { |v| Hash[*v] }
    add_coercer(Object => Hash) { |v| v.to_h }

    add_coercer(NilClass => {}) do |v, klass, parent, atr|
      InstanceCoercer::Hash.init({}, klass, parent, atr)
    end

    add_coercer(Array => {}) do |v, klass, parent, atr|
      InstanceCoercer::Hash.init(Hash[*v], klass, parent, atr)
    end

    add_coercer(Hash => {}) do |v, klass, parent, atr|
      InstanceCoercer::Hash.init(v, klass, parent, atr)
    end
  end
end
