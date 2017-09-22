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
    return @@debuging if class_variable_defined?(:@@debuging)
    @@debuging ||= false
  end

  def self.log?
    return @@log if class_variable_defined?(:@@log)
    @@log ||= true
  end

  def debug(&blk)
    @@debuging = true
    res = instance_exec(&blk)
    @@debuging = false
    res
  end

  def no_log(&blk)
    @@log = false
    res = instance_exec(&blk)
    @@log = true
    res
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
    if TestBase.log?
      super
      # puts caller.find { |line| line[/_test.rb/] }
    end
  end
end

Wardrobe.configure do |c|
  c.logger = TestLogger.new(STDOUT)#(File.open(File::NULL, 'w'))
end
