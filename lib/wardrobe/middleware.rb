module Wardrobe
  class Middleware
    attr_reader :name, :block, :use_if

    def initialize(name, block, use_if)
      @name = name
      @block = block
      @use_if = use_if
    end

    def <=>(other)
      priority <=> other.priority
    end
  end
end
