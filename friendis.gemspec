# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'friendis/version'

Gem::Specification.new do |spec|
  spec.name          = "friendis"
  spec.version       = Friendis::VERSION
  spec.authors       = ["Elad Meidar"]
  spec.email         = ["elad@eizesus.com"]
  spec.summary       = "Friendis implements friendship relationship between objects on Redis"
  spec.description   = "Friendis keeps all your friends close by!"
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_dependency 'redis'
end
