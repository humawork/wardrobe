# frozen_string_literal: true

module Wardrobe
  module Plugins
    module CoercibleOpenStruct
      extend Wardrobe::Plugin
      module ClassMethods
        def OpenStruct(klass)
          OpenStruct.new(klass: klass)
        end
      end
    end
  end
  register_plugin(:coercible_open_struct, Plugins::CoercibleOpenStruct)
end
