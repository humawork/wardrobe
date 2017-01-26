lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'atrs/version'

Gem::Specification.new do |spec|
  spec.name          = 'atrs'
  spec.version       = Atrs::VERSION
  spec.authors       = ['Eigil Sagafos']
  spec.email         = ['eigil@agens.no']
  spec.summary       = 'Attributes'
  spec.description   = 'Attributes'
  spec.homepage      = ''
  spec.license       = ''

  spec.files         = `git ls-files -z`.split("\x0")
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler',        '~> 1.7'
  spec.add_development_dependency 'rake',           '~> 11.0'
  spec.add_development_dependency 'minitest',       '~> 5.9'
  # spec.add_development_dependency 'guard',          '~> 2.14'
  # spec.add_development_dependency 'guard-minitest', '~> 2.4'
  spec.add_development_dependency 'minitest-utils', '~> 0.3'
  spec.add_development_dependency 'pry',            '~> 0.10.4'
  spec.add_development_dependency 'pry-byebug',     '~> 3.4'
end
