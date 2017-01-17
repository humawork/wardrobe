module Attributable
  module Plugins
    module OptionalGetter
      extend Attributable::Plugin

      option :getter, Boolean, default: true

    end
  end
end
