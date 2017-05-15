require 'test_helper'

class CreateClassFromHashTest < TestBase
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

    klass = Wardrobe.create_class(config)
    instance = klass.new
    assert_equal 'test@example.com', instance.email
  end
end
