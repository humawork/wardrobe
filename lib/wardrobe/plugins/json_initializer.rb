# frozen_string_literal: true

module Wardrobe
  module Plugins
    module JsonInitializer
      extend Wardrobe::Plugin

      def self.parse(json)
        raise InvalidJsonError unless json.match(/\A[\[{].+[\]}]\z/m)
        case parser.to_s
        when 'JSON'
          parser.parse(json, symbolize_names: true)
        when 'MultiJson'
          parser.load(json, symbolize_keys: true)
        end
      end

      def self.parser
        @parser ||= select_parser
      end

      def self.select_parser
        return MultiJson if defined? MultiJson
        return JSON if defined? JSON
        require 'json'
        JSON
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
