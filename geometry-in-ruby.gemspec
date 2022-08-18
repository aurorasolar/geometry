# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = "geometry-in-ruby"
  s.version     = '0.0.6'
  s.authors     = ["Brandon Fosdick", "Meseker Yohannes"]
  s.email       = ["myohannes@aurorasolar.com"]
  s.homepage    = "http://github.com/aurorasolar/geometry"
  s.summary     = %q{Geometric primitives and algoritms}
  s.description = %q{Geometric primitives and algorithms for Ruby}
  s.required_ruby_version = ">= 2.7.5", "< 3.2"

  s.rubyforge_project = "aurora_geometry"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency "matrix", "< 1.0"

  s.add_development_dependency "minitest"
  # s.add_runtime_dependency "rest-client"
end
