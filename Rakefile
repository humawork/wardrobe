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

task :plugins do
  require 'wardrobe'
  require 'pry'
  require 'pry-byebug'
  Dir['./lib/wardrobe/plugins/*.rb'].each { |f| require f }
  Wardrobe.plugins.each do |name, mod|
    puts "Plugin `#{name}`"
    mod.options.each do |opt|
      puts "    Option `#{opt.name}` (#{opt.klass}) default: `#{opt.default}`"
    end
  end
end
