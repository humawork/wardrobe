# frozen_string_literal: true

module Wardrobe
  module Plugins
    module Coercible
      module Refinements
        refine OpenStruct.singleton_class do
          def coerce(v, _atr)
            case v
            when self     then v
            when Hash     then OpenStruct.new(v)
            when NilClass then OpenStruct.new
            else
              raise UnsupportedError
            end
          end
        end

        refine OpenStruct do
          module OpenStructInstanceCoercer
            def _wardrobe_init(atr, coercer: nil)
              @_wardrobe_atr = atr
              @_wardrobe_coercer = coercer
              @_method_module = Module.new
              self.singleton_class.prepend(@_method_module)
              self
            end

            def _coerce(item)
              @_wardrobe_coercer.coerce(item, @_wardrobe_atr)
            end

            def dup
              duplicate = super
              duplicate.singleton_class.include(OpenStructInstanceCoercer)
              duplicate
            end

            def method_missing(method_name, value = nil)
              if method_name[/=$/]
                super(method_name, _coerce(value))
                @_method_module.instance_exec do
                  define_method(method_name) do |val|
                    super(_coerce(val))
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

          def coerce(v, atr)
            case v
            when Hash then coerce_hash(v, atr)
            when NilClass then coerce_hash({}, atr)
            else
              raise UnsupportedError
            end
          end

          def coerce_hash(h, atr)
            hash = h.map do |key, value|
              [Symbol.coerce(key, nil), klass.coerce(value, nil)]
            end.to_h
            open_struct = OpenStruct.new(hash)
            open_struct.singleton_class.include(OpenStructInstanceCoercer)
            open_struct._wardrobe_init(atr, coercer: klass)
            open_struct
          end
        end
      end
    end
  end
end
