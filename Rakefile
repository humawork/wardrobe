# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rake/testtask'

Rake::TestTask.new(:test) do |t|
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
end

Rake::TestTask.new(:bench) do |t|
  t.libs << 'test'
  t.pattern = 'test/**/*_bench.rb'
end

task :console do
  sh "irb -I #{File.dirname(__FILE__)}/lib -r wardrobe"
end

task default: :test
