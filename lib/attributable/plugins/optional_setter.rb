module Attributable
  module Plugins
    module OptionalSetter
      extend Attributable::Plugin

      option :setter, Boolean, default: true

      module InstanceMethods
        def _attribute_init(atr, value)
          super unless atr.respond_to?(:setter) && atr.setter == false
        end
      end

      module ClassMethods
        # def define_getter(atr)
        #   define_method(atr.getter_name) do
        #     instance_variable_get(atr.ivar_name)
        #   end
        # end

        def define_setter(atr)
          super unless atr.respond_to?(:setter) && atr.setter == false
        end
      end
    end
  end
end
