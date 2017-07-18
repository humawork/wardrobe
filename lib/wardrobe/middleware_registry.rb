module Wardrobe
  class OrderObject
    attr_reader :name, :before, :after

    def initialize(name, before, after)
      @name = name
      @before = before.to_set.freeze
      @after = after.to_set.freeze
      freeze
    end
  end

  class MiddlewareOrderError < StandardError

  end

  class MiddlewareRegistry
    attr_reader :middleware, :order

    def initialize
      @middleware = {}
      @order = []
    end

    def priority(middleware)
      @order.index(@order.find { |item| item.name == middleware.name })
    end

    def register(middleware, before, after)
      name = middleware.name
      raise 'Name taken' if @middleware[name]
      @middleware[name] = middleware
      add_to_ordered_array(OrderObject.new(name, before, after))
    end

    def add_to_ordered_array(new_item)
      if @order.empty?
        @order << new_item
      else
        # We have to figure out where to place the item.
        # This can be decided based on the before/after on the new item or in
        # any of the already added items.


        # To figure out the min_index for where we can place the new_item we
        # have to loop through the existing items and see if any of them have
        # referenced the new_item of if the new_item references any of the
        # exisiting items.

        min_index = @order.map.with_index { |item, index|
          # If the new_item has to be before the current enumerated item OR
          # the current enumerated item has to be after the new_item then we
          # keep the index
          if new_item.before.include?(item.name) || item.after.include?(new_item.name)
            index
          end
        }.compact.min

        max_index = @order.map.with_index { |item, index|
          # If the new_item has to be after the current enumerated item OR
          # the current_enumerated item has to be before the new_item then we
          # keep the index
          if new_item.after.include?(item.name) || item.before.include?(new_item.name)
            index
          end
        }.compact.max

        if min_index && max_index
          if min_index > (max_index)
            @order.insert(min_index, new_item)
          else
            raise MiddlewareOrderError, "Unable to add `#{new_item.name}` to registry. Illegal before/after ordering."
          end
        elsif min_index
          @order.insert(min_index, new_item)
        elsif max_index
          @order.insert(max_index + 1, new_item)
        else
          @order << new_item
        end
      end
    end
  end

  class << self
    attr_reader :setter_registery, :getter_registery
  end

  @setter_registery = MiddlewareRegistry.new
  @getter_registery = MiddlewareRegistry.new

  def self.getters
    getter_registery.middleware
  end

  def self.setters
    setter_registery.middleware
  end
end
