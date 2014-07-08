# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'journalist/version'

Gem::Specification.new do |spec|
  spec.name          = "journalist"
  spec.version       = Journalist::VERSION
  spec.authors       = ["Fauzan Qadri"]
  spec.email         = ["ojankill@gmail.com"]
  spec.summary       = %q{extracting web cookie for journal sites for injecting cookie to web browser}
  spec.description   = %q{extracting web cookie for journal sites for injecting cookie to web browser}
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "rails", "~> 4.1.1"
  spec.add_dependency "nokogiri", "~> 1.6.2"
  spec.add_dependency "mechanize"
  spec.add_dependency "redis", "~> 3.0.7"
  spec.add_dependency "sidekiq", "~> 3.0.2"

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rspec-rails"
end
