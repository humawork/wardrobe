# frozen_string_literal: true

module Wardrobe
  module Plugins
    module Validation

      class Validation < Hash
        def initialize(method, arg)
          self[:method] = method
          self[:arg] = arg
        end

        def method
          self[:method]
        end

        def arg
          self[:arg]
        end

        def args
          @args ||= begin
            arr = [method]
            arr << arg if arg
            arr
          end
        end

        SPECIAL_METHODS = Set.new([:each?, :each_key?, :each_value?])

        def type
          @type ||= begin
            if method[/^_.+_$/] || SPECIAL_METHODS.include?(method)
              :special
            else
              :value
            end
          end
        end

        def &(other)
          if method == :_and_
            arg << other
            self
          else
            self.class.new(:_and_, [self, other])
          end
        end

        def |(other)
          if method == :_or_
            arg << other
            self
          else
            self.class.new(:_or_, [self, other])
          end
        end

        def >(other)
          self.class.new(:_then_, [self, other])
        end
      end
    end
  end
end
