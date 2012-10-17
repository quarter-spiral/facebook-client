# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'facebook-client/version'

Gem::Specification.new do |gem|
  gem.name          = "facebook-client"
  gem.version       = Facebook::Client::VERSION
  gem.authors       = ["Thorben Schröder"]
  gem.email         = ["thorben@quarterspiral.com"]
  gem.description   = %q{Wrapper for the Quarter Spiral Facebook integration}
  gem.summary       = %q{Wrapper for the Quarter Spiral Facebook integration}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency 'fb_graph'
end
