module Wardrobe
  module Coercible
    module InstanceCoercer
      module OpenStruct
        def self.init(val, klass, parent)
          val = val.map do |key, value|
            [
              Wardrobe::Coercible.coerce(key, to: Symbol, parent: parent),
              Wardrobe::Coercible.coerce(value, to: klass.klass, parent: parent)
            ]
          end.to_h
          open_struct = ::OpenStruct.new(val)
          open_struct.singleton_class.include(self)
          open_struct._wardrobe_init(klass, parent: parent)
          open_struct
        end

        def _wardrobe_init(klass, parent: nil)
          @_wardrobe_coercer = klass.klass
          @_wardrobe_parent = parent
          @_method_module = Module.new
          self.singleton_class.prepend(@_method_module)
          self
        end

        def _coerce(item)
          Wardrobe::Coercible.coerce(item, to: @_wardrobe_coercer, parent: @_wardrobe_parent)
        end

        def dup
          duplicate = super
          duplicate.singleton_class.include(InstanceCoercer::OpenStruct)
          duplicate
        end

        def method_missing(method_name, value = nil)
          if method_name[/=$/]
            super(method_name, _coerce(value))
            unless @_method_module.method_defined?(method_name)
              @_method_module.instance_exec do
                define_method(method_name) do |val|
                  super(_coerce(val))
                end
              end
            end
          else
            super(method_name)
          end
        end

        def []=(key, val)
          send("#{key}=", val)
        end
      end
    end
  end
end
