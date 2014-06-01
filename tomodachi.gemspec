# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tomodachi/version'

Gem::Specification.new do |spec|
  spec.name          = 'tomodachi'
  spec.version       = Tomodachi::VERSION
  spec.authors       = ['Takashi Kokubun']
  spec.email         = ['takashikkbn@gmail.com']
  spec.description   = %q{Automatic follow back tool with Twitter streaming API}
  spec.summary       = %q{Automatic follow back tool with Twitter streaming API}
  spec.homepage      = 'https://github.com/k0kubun/tomodachi'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = ['tomodachi']
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'twitter', '~> 5.1.1'
  spec.add_dependency 'thor', '~> 0.18.1'
  spec.add_dependency 'userstream', '~> 1.3.0'
  spec.add_dependency 'oauth', '~> 0.4.7'
  spec.add_dependency 'unindent', '~> 1.0'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rspec', '~> 2.14.0'
end
