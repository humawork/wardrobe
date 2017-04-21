module Atrs
  class UnavailableOptionError < StandardError; end

  @setters = {}
  @getters = {}

  def self.setters; @setters; end
  def self.getters; @getters; end

  class SetterGetter
    attr_reader :name, :priority, :block, :use_if

    def initialize(name, priority, block, use_if)
      @name = name
      @priority = priority
      @block = block
      @use_if = use_if
    end

    def <=>(other)
      priority <=> other.priority
    end
  end

  Getter = Struct.new(:name, :priority, :getter, :use_if)
  Setter = Struct.new(:name, :priority, :setter, :use_if)

  def self.register_setter(name:, priority:, setter:, use_if: ->(atr) {true})
    raise 'Name taken' if setters[name]
    if res = setters.find { |k,v| v.priority == priority }
      raise "Prioriy #{priority} in use by #{res.name}"
    end
    setters[name] = SetterGetter.new(name, priority, setter, use_if)
  end

  def self.register_getter(name:, priority:, getter:, use_if: ->(atr) {true})
    raise 'Name taken' if getters[name]
    raise 'Prioriy in use' if getters.any? { |k,v| v.priority == priority }
    getters[name] = SetterGetter.new(name, priority, getter, use_if)
  end

  Atrs.register_getter(
    name: :getter,
    priority: 0,
    use_if: ->(atr) { true },
    getter: ->(value, atr, instance) {
      instance.instance_variable_get(atr.ivar_name)
    }
  )
  Atrs.register_setter(
    name: :coercer,
    priority: -100,
    use_if: ->(atr) { true },
    setter: ->(value, atr, instance) {
      atr.coerce(value)
    }
  )
  Atrs.register_setter(
    name: :setter,
    priority: 100,
    use_if: ->(atr) { true },
    setter: ->(value, atr, instance) {
      instance.instance_variable_set(atr.ivar_name, value)
    }
  )
  DEFAULT_GETTERS = [
    Atrs.getters[:getter]
  ].freeze

  DEFAULT_SETTERS = [
    Atrs.setters[:coercer],
    Atrs.setters[:setter]
  ].freeze

  class Attribute

    using Coercions
    attr_reader :name, :klass, :options, :ivar_name, :setter_name, :store

    def initialize(name, klass, defining_object, config, store, **options, &blk)
      @name = name
      @ivar_name = "@#{name}"
      @setter_name = "#{name}="
      @klass = klass
      @options = validate_options(options, defining_object, config, store)
      freeze
    end

    def getters(instance)
      (instance.class.atrs_config.option_store.values.map do |option|
        option.getter if option.use_getter_for_atr?(self)
      end + DEFAULT_GETTERS).compact.sort_by(&:priority)
    end

    def setters(instance)
      (instance.class.atrs_config.option_store.values.map do |option|
        option.setter if option.use_setter_for_atr?(self)
      end + DEFAULT_SETTERS).compact.sort_by(&:priority)
    end

    def coerce(val)
      klass.coerce(val, self)
    rescue Coercions::UnsupportedError => e
      raise Coercions::UnsupportedError, "Can't coerce #{val.class} `#{val}` into #{klass}"
    end

    def merge(other, defining_object, config, store)
      merged_options = options.dup
      other.options.each do |key, value|
        if merged_options[key]
          case value
          when Hash
            merged_options[key] = merged_options[key].merge(value)
          else
            raise "Unsupported attribute operation"
          end
        else
          merged_options[key] = value.dup
        end
      end
      self.class.new(
        name,
        other.klass,
        defining_object,
        config,
        store,
        merged_options
      )
    end

    private

    def validate_options(options, defining_object, config, store)
      options.each do |name, _|
        raise UnavailableOptionError unless config.option_store[name]
        define_singleton_method(name) { @options[name] }
      end
    end
  end
end
