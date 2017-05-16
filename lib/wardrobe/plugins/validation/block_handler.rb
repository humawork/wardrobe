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

        def type
          @type ||= method[/^_.+_$/] ? :special : :value
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

      class CustomHash < Hash
        def initialize(**args)
          merge!(args)
        end

        def &(other)
          if self[:and]
            self[:and] << other
            self
          else
            self.class.new(_and_: [self, other])
          end
        end

        def >(other)
          self.class.new(_then_: [self, other])
        end

        def |(other)
          if self[:or]
            self[:or] << other
            self
          else
            self.class.new(_or_: [self, other])
          end
        end
      end

      METHODS_WITHOUT_ARGUMENTS = [
        :empty?,
        :filled?,
        :odd?,
        :even?
      ]

      METHODS_WITH_ARGUMENTS = [
        :format?,
        :size?,
        :min_size?,
        :max_size?,
        :included_in?,
        :excluded_from?,
        :gt?,
        :lt?,
        :lteq?,
        :gteq?
      ]

      METHODS_WITH_BLOCK = [
        :each?,
        :each_key?,
        :each_value?
      ]

      TYPE_METHODS = {
        str?: String,
        sym?: Symbol,
        int?: Integer,
        float?: Float,
        bool?: Boolean,
        date?: Date,
        time?: Time,
        date_time?: DateTime,
        array?: Array,
        hash?: Hash
      }

      class BlockHandler
        attr_reader :result

        def initialize(&blk)
          @result = instance_exec(&blk)
        end

        private

        def optional(&blk)
          Validation.new(:_optional_, instance_exec(&blk))
          # CustomHash.new(_optional_: instance_exec(&blk))
        end

        TYPE_METHODS.each do |name, klass|
          define_method(name) do
            Validation.new(:type?, klass)
            # CustomHash.new(type?: klass)
          end
        end

        METHODS_WITHOUT_ARGUMENTS.each do |name|
          define_method(name) do
            Validation.new(name.to_sym, nil)
            # CustomHash.new(name => nil)
          end
        end

        METHODS_WITH_ARGUMENTS.each do |name|
          define_method(name) do |value|
            Validation.new(name.to_sym, value)
            # CustomHash.new(name => value)
          end
        end

        METHODS_WITH_BLOCK.each do |name|
          define_method(name) do |&blk|
            raise "Error. No block given" unless blk
            Validation.new(name.to_sym, instance_exec(&blk))
            # CustomHash.new(name => instance_exec(&blk))
          end
        end
      end
    end
  end
end
