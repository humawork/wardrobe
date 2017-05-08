require 'test_helper'

class HtmlInitializerTest < Minitest::Test
  class Article
    include Wardrobe
    plugin :html_initializer
    attribute :title, String, html_selector: proc { |doc| doc.at_xpath('//div/h1')&.text }
  end

  def setup
    @article_html = Article.new('<html><div><h1>Html</h1></div></html>')
    @article_hash = Article.new(title: 'Hash')
  end

  def test_html_parsing
    assert_equal 'Html', @article_html.title
    assert_equal 'Hash', @article_hash.title
  end
end
