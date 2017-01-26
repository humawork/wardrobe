module Atrs
  module Plugins
    module Present
      extend Atrs::Plugin

      module InstanceMethods
        def _present(*args)
          _attribute_set.set.transform_values do |value|
            send(value.name)._present(*args)
          end
        end
      end
    end
  end
end
