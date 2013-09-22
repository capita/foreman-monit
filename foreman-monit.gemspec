# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'foreman-monit/version'

Gem::Specification.new do |gem|
  gem.name          = 'foreman-monit'
  gem.version       = Foreman::Monit::VERSION
  gem.authors       = ['Sebastian Georgi']
  gem.email         = %w(sgeorgi@capita.de)
  gem.description   = %q{Outputs bash-wrapped launchers and control files for monit}
  gem.summary       = %q{...}
  gem.homepage      = ''

  gem.files         = `git ls-files`.split($/)
  gem.add_dependency('foreman')
  gem.add_dependency('thor')
  gem.add_development_dependency('rspec')
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = %w(lib)
end
