# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'clipr/version'

Gem::Specification.new do |gem|
  gem.name          = "clipr"
  gem.version       = Clipr::VERSION
  gem.authors       = ["Russell Garner"]
  gem.email         = ["rgarner@zephyros-systems.co.uk"]
  gem.description   = %q{Trims single-lap Garmin TCX files to remove empty space at the end of the file}
  gem.summary       = %q{Trim Garmin TCX files}
  gem.homepage      = "http://github.com/rgarner/clipr"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
