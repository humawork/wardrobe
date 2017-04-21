require 'test_helper'

class IvyPresenterTest < Minitest::Test
  class Article
    include Atrs
    plugin :presenter
    plugin :ivy_presenter
    attributes source: true do
      attribute :id,    Integer
      preset :one do
        attribute :title, String
        attribute :author, String
        preset :two do
          attribute :body, String
        end
      end
      source false do
        attribute :body_text, String
      end
    end

    def body_text
      'Lorem ipsum...'
    end
  end


  def setup
    @article = Article.new(
      id: 1,
      title: 'Article One',
      author: 'Test Tester',
      body: '<p>Lorem ipsum...</p>'
    )
  end

  def test_preset_one
    result = @article._ivy_present(preset: :one)
    assert_equal 3, result.keys.length
  end

  def test_preset_two
    result = @article._ivy_present(preset: :two)
    assert_equal 1, result.keys.length
  end

  def test_source_true
    result = @article._ivy_present(source: true)
    assert_equal 4, result.keys.length
  end

  def test_source_false
    result = @article._ivy_present(source: false)
    assert_equal 'Lorem ipsum...', result[:body_text]
    assert_equal 1, result.keys.length
  end
end
