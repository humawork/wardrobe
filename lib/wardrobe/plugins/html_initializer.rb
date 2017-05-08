module Wardrobe
  module Plugins
    module HtmlInitializer
      extend Wardrobe::Plugin

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
        def initialize(html = nil, **args)
          if html
            define_singleton_method(:_attribute_init) do |atr, doc, name|
              value = atr.options[:html_selector].call(doc, atr, self)
              send(atr.setter_name, value)
            end
            html = HtmlInitializer.parse(html) if html.is_a?(String)
            _wardrobe_init(html)
          else
            super(**args)
          end
        end

        def _attribute_init(atr, html, name)
          return super if html.is_a?(Hash)
          send(atr.setter_name, html)
        end
      end
    end
  end
  register_plugin(:html_initializer, Plugins::HtmlInitializer)
end
