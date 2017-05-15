$:.unshift File.expand_path('../../lib', __FILE__)
require 'wardrobe'
require 'http'
require 'pry'
require 'pry-byebug'
require 'awesome_print'

class Image
  include Wardrobe
  plugin :html_initializer
  plugin :presenter
  attribute :caption, String, html_selector: proc { |doc| doc.at_css('figcaption span.caption-text')&.text }
  attribute :credits, String, html_selector: proc { |doc| doc.at_css('figcaption span.credit').xpath('text()')&.text&.strip }
  attribute :url, String, html_selector: proc { |doc| doc.at_css('div.image img')&.attribute('data-jumbosrc')&.value || doc.attribute('itemid')&.value }
end

class Article
  include Wardrobe
  plugin :html_initializer
  plugin :presenter
  attribute :title, String, html_selector: proc { |doc| doc.at_css('header div#story-meta h1#headline')&.text }
  attribute :headline, String, html_selector: proc { |doc| doc.at_css('header div#story-meta p#story-deck')&.text }
  attribute :featured_images, Image, html_selector: proc { |doc| doc.at_css('header figure.media') }
  attribute :published_at, Time, html_selector: proc { |doc| doc.at_css('meta[property="article:published"]').attribute('content')&.value }
  attribute :modified_at, Time, html_selector: proc { |doc| doc.at_css('meta[property="article:modified"]').attribute('content')&.value }
  attribute :tags, Array[String], html_selector: proc { |doc| doc.css('meta[property="article:tag"]').map { |t| t.attribute('content')&.value } }
  attribute :body, Array, html_selector: proc { |doc, _atr, instance|
    instance.class.parse_body_html(doc.at_css('article#story').children)
  }

  def self.find(url)
    res = HTTP.get('https://www.nytimes.com' + url)
    res = HTTP.cookies(res.cookies).get(res.headers['Location'])
    res = HTTP.cookies(res.cookies).get(res.headers['Location'])
    new res.to_s
  end

  def self.parse_body_html(html)
    html.css('p.story-body-text, figure.media').map do |item|
      if item.name == 'p'
        item.to_html
      elsif item.name == 'figure'
        # Support video
        Image.new(item)
      end
    end
  end

end

url = '/2017/05/07/sports/baseball/wrigley-field-bullpens-renovations.html'
# url = '/2017/05/03/magazine/a-look-inside-airbuss-epic-assembly-line.html'
article = Article.find(url)
ap article._present
ap Article
