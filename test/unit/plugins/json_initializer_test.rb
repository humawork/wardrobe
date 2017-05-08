require 'test_helper'

class JsonInitializerTest < Minitest::Test
  class Article
    include Atrs
    plugin :json_initializer
    attribute :title, String
  end

  def setup
    if Atrs::Plugins::JsonInitializer.instance_variable_defined?(:@parser)
      Atrs::Plugins::JsonInitializer.remove_instance_variable(:@parser)
    end
  end

  def initiate_articles
    @article_json = Article.new('{"title":"Json"}')
    @article_hash = Article.new(title: 'Hash')
  end

  def do_in_child
    read, write = IO.pipe

    pid = fork do
      read.close
      result = yield
      Marshal.dump(result, write)
      exit!(0)
    end

    write.close
    result = read.read
    Process.wait(pid)
    raise 'child failed' if result.empty?
    Marshal.load(result)
  end

  def test_multi_json_loaded
    res = do_in_child do
      require 'multi_json'
      assert_equal MultiJson, Atrs::Plugins::JsonInitializer.parser
      initiate_articles
      {
        json: @article_json.title,
        hash: @article_hash.title
      }
    end

    assert_equal 'Json', res[:json]
    assert_equal 'Hash', res[:hash]
  end

  def test_json_loaded
    res = do_in_child do
      require 'json'
      assert_equal JSON, Atrs::Plugins::JsonInitializer.parser
      initiate_articles
      {
        json: @article_json.title,
        hash: @article_hash.title
      }
    end

    assert_equal 'Json', res[:json]
    assert_equal 'Hash', res[:hash]
  end
end
