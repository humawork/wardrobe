require 'benchmark/ips'
require 'pry'
require 'pry-byebug'
require 'ostruct'

procs = [
  Proc.new { |val, instance| instance.name + val },
  Proc.new { |val, instance| instance.name + val },
  Proc.new { |val, instance| instance.name + val }
]

lambdas = [
  lambda { |val, instance| instance.name + val },
  lambda { |val, instance| instance.name + val },
  lambda { |val, instance| instance.name + val }
]

modules = [
  Module.new {
    def self.call(val, instance)
      instance.name + val
    end
  },
  Module.new {
    def self.call(val, instance)
      instance.name + val
    end
  },
  Module.new {
    def self.call(val, instance)
      instance.name + val
    end
  }
]

classes = [
  Class.new {
    def call(val, instance)
      instance.name + val
    end
  },
  Class.new {
    def call(val, instance)
      instance.name + val
    end
  },
  Class.new {
    def call(val, instance)
      instance.name + val
    end
  }
]

instance = OpenStruct.new(name: 'Yes! ')

procs.inject('') do |val, item|
  item.call(val, instance)
end

modules.inject('') do |val, item|
  item.call(val, instance)
end


Benchmark.ips do |x|
  x.report('Procs') {
    procs.inject('') do |val, item|
      item.call(val, instance)
    end
  }
  x.report('Lambdas') {
    lambdas.inject('') do |val, item|
      item.call(val, instance)
    end
  }
  x.report('Modules') {
    modules.inject('') do |val, item|
      item.call(val, instance)
    end
  }
  x.report('Classes') {
    classes.inject('') do |val, item|
      item.new.call(val, instance)
    end
  }
  x.compare!
end
