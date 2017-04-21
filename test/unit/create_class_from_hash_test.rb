require 'test_helper'

class CreateClassFromHashTest < Minitest::Test
  def test_one
    config = {
      plugins: [
        :default
      ],
      attributes: [
        {
          name: :email,
          class: 'String',
          options: {
            default: 'test@example.com'
          }
        },
        {
          name: :name,
          class: 'String'
        }
      ]
    }

    klass = Atrs.create_class(config)
    instance = klass.new
    assert_equal 'test@example.com', instance.email
  end
end
