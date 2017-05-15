require "simplecov"
SimpleCov.start

require 'minitest/autorun'
require 'assertions'
require 'wardrobe'

require 'pry'
require 'pry-byebug'

LOG_MESSAGES = []

class TestBase < Minitest::Test
  def log_messages
    LOG_MESSAGES
  end

  def teardown
    LOG_MESSAGES.clear
  end
end

class TestLogger < Logger
  def format_message(severity, datetime, progname, msg)
    LOG_MESSAGES << [severity, datetime, progname, msg]
    super
  end
end

Wardrobe.configure do |c|
  c.logger = TestLogger.new(File.open(File::NULL, "w"))
end
