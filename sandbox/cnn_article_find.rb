$:.unshift File.expand_path('../../lib', __FILE__)
require_relative '../lib/atrs'
require 'http'
require 'pry'
require 'pry-byebug'

class Article
  include Atrs
  plugin :html_initializer
  attribute :title, String, html_selector: ->(h) { h.at_xpath('//h1[@class="pg-headline"]').text }

  def self.find(url)
    new(HTTP.get(url).to_s)
  end
end


article = Article.find('http://edition.cnn.com/2017/04/27/sport/yorkshire-cycling-revolution/index.html')
binding.pry
article.title
