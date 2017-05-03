module Atrs
  module Plugins
    module HtmlInitializer
      extend Atrs::Plugin

      option :html_selector, Proc

      def self.parse(html)
        parser.parse(html)
      end

      def self.parser
        @parser ||= begin
          unless defined? Nokogiri
            require 'nokogiri'
          end
          Nokogiri::HTML
        end
      end

      module InstanceMethods
        def initialize(html_string = nil, **args)
          if html_string
            define_singleton_method(:_attribute_init) do |atr, html, name|
              value = atr.options[:html_selector].call(html)
              send(atr.setter_name, value)
            end
            html = HtmlInitializer.parse(html_string)
            _atrs_init(html)
          else
            super(**args)
          end
        end

        def _attribute_init(atr, html, name)
          return super if html.is_a?(Hash)
          binding.pry
          send(atr.setter_name, html)
        end
      end
    end
  end
  register_plugin(:html_initializer, Plugins::HtmlInitializer)
end
