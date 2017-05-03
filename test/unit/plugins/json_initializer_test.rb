require 'test_helper'

class JsonInitializerTest < Minitest::Test
  class Article
    include Atrs
    plugin :json_initializer
    attribute :title, String
  end

  def setup
    @article_json = Article.new('{"title":"Json"}')
    @article_hash = Article.new(title: 'Hash')
  end

  def test_json_parsing
    assert_equal 'Json', @article_json.title
    assert_equal 'Hash', @article_hash.title
  end
end
