module Atrs
  class Option
    attr_reader :name, :klass, :plugin, :options

    def initialize(name, klass, plugin, **kargs, &blk)
      @name = name
      @klass = klass
      @plugin = plugin
      @options = kargs
      freeze
    end

  end
end
