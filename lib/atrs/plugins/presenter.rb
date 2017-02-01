require_relative 'presenter/refinements'
module Atrs
  module Plugins
    module Presenter
      extend Atrs::Plugin

      option :preset, Array
      # option :present, Proc

      # module ClassMethods
      #   def present(&blk)
      #     sss = caller
      #     binding.pry
      #   end
      # end

      module InstanceMethods
        using Refinements
        def _present(*args)
          _attribute_set.set.transform_values do |value|
            send(value.name)._present(*args)
          end
        end
      end
    end
  end
  register_plugin(:presenter, Plugins::Presenter)
end
