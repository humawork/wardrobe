# frozen_string_literal: true
require_relative 'instance_coercer/set'

module Wardrobe
  module Coercible
    add_coercer(NilClass => Set)     { |_, klass| klass.new }
    add_coercer(Set => Set)          { |v| v }
    add_coercer(Array => Set)        { |v| v.to_set }

    add_coercer(NilClass => Set.new) do |v, klass, parent, atr|
      InstanceCoercer::Set.init(klass.class.new, klass, parent, atr)
    end

    add_coercer(Set => Set.new) do |v, klass, parent, atr|
      InstanceCoercer::Set.init(v, klass, parent, atr)
    end

    add_coercer(Array => Set.new) do |v, klass, parent, atr|
      InstanceCoercer::Set.init(v, klass, parent, atr)
    end
  end
end
