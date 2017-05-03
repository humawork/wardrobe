# frozen_string_literal: true

module Atrs
  module Plugins
    module JsonInitializer
      extend Atrs::Plugin

      def self.parse(json)
        raise InvalidJsonError unless json.match(/\A[\[{].+[\]}]\z/m)
        parser.parse(json, symbolize_names: true)
      end

      def self.parser
        @parser ||= select_parser
      end

      def self.select_parser
        if defined? MutliJson
          binding.pry
        elsif defined? JSON
          binding.pry
        else
          require 'json'
          JSON
        end
      end

      module InstanceMethods
        def initialize(json_string = nil, **args)
          if json_string
            super(**JsonInitializer.parse(json_string))
          else
            super(**args)
          end
        end
      end
    end
  end
  register_plugin(:json_initializer, Plugins::JsonInitializer)
end
