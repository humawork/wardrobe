module Wardrobe
  module Plugins
    module Validation

      class Validation < Hash
        def initialize(method, argument)
          self[:method] = method
          self[:argument] = argument
        end

        def method
          self[:method]
        end

        def argument
          self[:argument]
        end

        def args
          @args ||= begin
            arr = [ method ]
            arr << argument if argument
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
            argument << other
            self
          else
            self.class.new(:_and_, [self, other])
          end
        end

        def |(other)
          if method == :_or_
            argument<< other
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
