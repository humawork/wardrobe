# require 'test_helper'
#
# class ParamConfig
#   include Atrs
#   plugin :immutable
#   attribute :name, String
#   attribute :klass, Symbol
# end
#
# class ChildTestConfig
#   include Atrs
#   plugin :immutable
#   attribute :name, String
#   attribute :params, Array[ParamConfig]
# end
#
# class TestConfig
#   include Atrs
#   plugin :immutable
#   attribute :title, String
#   attribute :child, ChildTestConfig
# end
#
# class Base
#   include Atrs
#   plugin :configurable
#   configurable :config, :configure, TestConfig
#   configure do |config|
#     config.title = 'Title'
#   end
# end
#
# # class Child < Base
# #   configure do |config|
# #     config.set(title: 'Title in Child')
# #     # config.title = 'Title in Child'
# #     # config.child.name = 'Name in Child'
# #   end
# # end
# #
# # class Child2 < Child
# #   configure do |config|
# #     config.set(title: 'Title in Child2')
# #     # config.title = 'Title in Child2'
# #     # config.child.name = 'Name in Child2'
# #   end
# # end
#
#
# class ClassConfigTest < Minitest::Test
#   def test_child_class
#     binding.pry
#     assert_equal 'Title', Base.config.title
#     assert_nil Base.config.child.name
#   end
#
#   # def test_modified_child_class
#   #   assert_equal 'Title in Child', Child.config.title
#   #   assert_equal 'Name in Child', Child.config.child.name
#   # end
# end
