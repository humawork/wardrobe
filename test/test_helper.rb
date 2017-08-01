require 'simplecov'
SimpleCov.start do
  # TODO: Figure out a way to include these files in the report. Fork is used.
  add_filter 'test/unit/plugins/json_initializer_test.rb'
  add_filter 'lib/wardrobe/plugins/json_initializer.rb'
end

require 'pry'
require 'pry-byebug'

require 'minitest/autorun'
require 'assertions'

class TestBase < Minitest::Test
  def log_messages
    LOG_MESSAGES
  end

  def setup
    LOG_MESSAGES.clear
  end

  def teardown
    LOG_MESSAGES.clear
  end

  def self.debuging?
    @@debuging ||= false
  end

  def debug(&blk)
    @@debuging = true
    instance_exec(&blk)
    @@debuging = false
  end
end

class Object
  def debug?
    TestBase.debuging?
  end
end
require 'wardrobe'

module TestPlugin
  extend Wardrobe::Plugin
  option :preset, Set
end

Wardrobe.register_plugin(:test_plugin, TestPlugin)

LOG_MESSAGES = []

class TestLogger < Logger
  def format_message(severity, datetime, progname, msg)
    LOG_MESSAGES << [severity, datetime, progname, msg]
    super
  end
end

Wardrobe.configure do |c|
  c.logger = TestLogger.new(File.open(File::NULL, "w"))
end
