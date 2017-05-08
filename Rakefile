# frozen_string_literal: true
require 'bundler/gem_tasks'
require 'rake/testtask'

# This was used to add env before running test
# module FileUtils
#   def ruby(*args, &block)
#     options = (Hash === args.last) ? args.pop : {}
#     if args.length > 1
#       sh(*([RUBY] + args + [options]), &block)
#     else
#       if ENV['ATRS_STRATEGY']
#         sh("ATRS_STRATEGY=\"#{ENV['ATRS_STRATEGY']}\" #{RUBY} #{args.first}", options, &block)
#       else
#         sh("#{RUBY} #{args.first}", options, &block)
#       end
#     end
#   end
# end

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
