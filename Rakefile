# frozen_string_literal: true
require 'bundler/gem_tasks'

task :test do
  require 'rake/testtask'
  Rake::TestTask.new do |t|
    t.libs << 'test'
    t.pattern = 'test/**/*_test.rb'
  end
end

task default: :test
