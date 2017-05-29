module Wardrobe
  module Plugins
    module Validation
      METHODS_WITHOUT_ARGUMENTS = %i[
        empty?
        filled?
        odd?
        even?
      ].freeze

      METHODS_WITH_ARGUMENTS = %i[
        format?
        size?
        min_size?
        max_size?
        gt?
        lt?
        lteq?
        gteq?
      ].freeze

      METHODS_WITH_ARRAY_ARGUMENT = %i[
        included_in?
        excluded_from?
      ].freeze

      METHODS_WITH_BLOCK = %i[
        each?
        each_key?
        each_value?
      ].freeze

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
      }.freeze

      class BlockHandler
        attr_reader :result

        def initialize(&blk)
          @result = instance_exec(&blk)
        end

        private

        def optional(&blk)
          Validation.new(:_optional_, instance_exec(&blk))
        end

        TYPE_METHODS.each do |name, klass|
          define_method(name) do
            Validation.new(:type?, klass)
          end
        end

        METHODS_WITHOUT_ARGUMENTS.each do |name|
          define_method(name) do
            Validation.new(name.to_sym, nil)
          end
        end

        METHODS_WITH_ARGUMENTS.each do |name|
          define_method(name) do |value|
            Validation.new(name.to_sym, value)
          end
        end

        METHODS_WITH_ARRAY_ARGUMENT.each do |name|
          define_method(name) do |*args|
            Validation.new(name.to_sym, args.flatten(1))
          end
        end

        METHODS_WITH_BLOCK.each do |name|
          define_method(name) do |&blk|
            raise 'Error. No block given' unless blk
            Validation.new(name.to_sym, instance_exec(&blk))
          end
        end
      end
    end
  end
end
