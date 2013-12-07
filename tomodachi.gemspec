# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tomodachi/version'

Gem::Specification.new do |spec|
  spec.name          = 'tomodachi'
  spec.version       = Tomodachi::VERSION
  spec.authors       = ['Takashi Kokubun']
  spec.email         = ['takashikkbn@gmail.com']
  spec.description   = %q{Twitter follower management tool}
  spec.summary       = %q{Twitter follower management tool}
  spec.homepage      = 'https://github.com/tkkbn/tomodachi'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = ['tomodachi']
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'twitter'
  spec.add_dependency 'thor'
  spec.add_dependency 'userstream'
  spec.add_dependency 'oauth'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rspec'
end
