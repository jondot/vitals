# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'vitals/version'

Gem::Specification.new do |spec|
  spec.name          = 'vitals'
  spec.version       = Vitals::VERSION
  spec.authors       = ['Dotan Nahum']
  spec.email         = ['jondotan@gmail.com']

  spec.summary       = 'Flexible StatsD instrumentation for Rails, Rack, Grape and more'
  spec.description   = 'Flexible StatsD instrumentation for Rails, Rack, Grape and more'
  spec.homepage      = 'https://github.com/jondot/vitals'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features|integration)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'statsd-ruby', '~> 1.3.0'

  spec.add_development_dependency 'guard-rubocop', '~> 1.2.0'
  spec.add_development_dependency 'guard-minitest', '~> 2.4.4'
  spec.add_development_dependency 'bundler', '~> 1.11'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'minitest', '~> 5.0'
  spec.add_development_dependency 'rack-test', '~> 0.6.3'
  spec.add_development_dependency 'rr', '~> 1.1.2'
  spec.add_development_dependency 'benchmark-ipsa', '~> 0.2.0'

  spec.add_development_dependency 'coveralls', '~> 0.8.13'
  # integrations
  # TODO we should test these under isolated environment while removing
  # these from here and running without bundler, inside docker, or by
  # doing what newrelic does - which is hooking into bundler and Gemfile so that
  # we simulate different bundler environment, so,
  # we should test many versions of rails, grape, and so on with the same
  # set of integration tests
  # for now, we keep latest versions
  spec.add_development_dependency 'grape', '~> 0.15.0'
  spec.add_development_dependency 'activesupport', '~> 4.2.6'
  spec.add_development_dependency 'sinatra', '~> 1.4.7'
  spec.add_development_dependency 'byebug', '~> 8.2.2'
end
