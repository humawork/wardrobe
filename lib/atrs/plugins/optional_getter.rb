module Atrs
  module Plugins
    module OptionalGetter
      extend Atrs::Plugin

      option :getter, Boolean, default: true

    end
  end
  register_plugin(:optional_getter, Plugins::OptionalGetter)
end
