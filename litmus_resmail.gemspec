# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "litmus_resmail/version"

Gem::Specification.new do |s|
  s.name        = "litmus_resmail"
  s.version     = LitmusResmail::VERSION
  s.authors     = ["Charles Anderson"]
  s.email       = ["master.sparkle@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{A simple wrapper around the Litmus reseller email analytics API.}
  s.description = %q{A simple wrapper around the Litmus reseller email analytics API.}

  s.rubyforge_project = "litmus_resmail"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_development_dependency "rspec"
  s.add_runtime_dependency "hashie"
  # s.add_runtime_dependency "rest-client"
end
