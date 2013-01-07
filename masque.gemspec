# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'masque/version'

Gem::Specification.new do |gem|
  gem.name          = "masque"
  gem.version       = Masque::VERSION
  gem.authors       = ["uu59"]
  gem.email         = ["k@uu59.org"]
  gem.description   = %q{JavaScript enabled web crawler kit}
  gem.summary       = %q{JavaScript enabled web crawler kit}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  gem.add_dependency "headless"

  # capybara-webkit 0.14.0+ require capybara 2.0,
  # but latest(1.0.2) poltergeist uses 1.x
  # https://github.com/thoughtbot/capybara-webkit/blob/v0.14.0/capybara-webkit.gemspec
  # https://github.com/jonleighton/poltergeist/blob/v1.0.2/poltergeist.gemspec
  #
  # (poltergeist is working in progress)
  # https://github.com/jonleighton/poltergeist/pull/208
  gem.add_dependency "capybara"
  gem.add_dependency "capybara-webkit", "0.13.0"
  gem.add_dependency "poltergeist", "1.0.2"
  gem.add_development_dependency "rspec", "~> 2.11"
  gem.add_development_dependency "sinatra"
  gem.add_development_dependency "simplecov"
  gem.add_development_dependency "multi_json"
end
