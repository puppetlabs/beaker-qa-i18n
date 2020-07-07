# -*- encoding: utf-8 -*-
$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)
require 'beaker-qa-i18n/version'

Gem::Specification.new do |s|
  s.name        = "beaker-qa-i18n"
  s.version     = Beaker::DSL::Helpers::BeakerQaI18n::Version::STRING
  s.authors     = ["Puppetlabs"]
  s.email       = ["qe-team@puppetlabs.com"]
  s.homepage    = "https://github.com/puppetlabs/beaker-qa-i18n"
  s.summary     = %q{Beaker DSL Extension Helpers to assist in testing i18n!}
  s.description = %q{For use for the Beaker acceptance testing tool}
  s.license     = 'Apache2'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # Testing dependencies
  s.add_development_dependency 'rspec', '~> 3.0'
  s.add_development_dependency 'rspec-its'
  s.add_development_dependency 'fakefs', '~> 0.6'
  s.add_development_dependency 'rake', '~> 13.0'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'pry', '~> 0.10'

  # Documentation dependencies
  s.add_development_dependency 'yard'
  s.add_development_dependency 'markdown'
  s.add_development_dependency 'thin'

  # Run time dependencies
  s.add_runtime_dependency 'stringify-hash', '~> 0.0.0'

end

