# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'frontend_rescue/version'

Gem::Specification.new do |spec|
  spec.name          = "frontend_rescue"
  spec.version       = FrontendRescue::VERSION
  spec.authors       = ["Jim Durand"]
  spec.email         = ["me@jdurand.com"]
  spec.summary       = "Provides a backend endpoint for your frontend JavaScript application to send errors to when they’re caught"
  spec.description   = "Provides a backend endpoint for your frontend JavaScript application to send errors to when they’re caught. This makes it easier to integrate your frontend stack traces to your backend analytics."
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "rack"

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end
