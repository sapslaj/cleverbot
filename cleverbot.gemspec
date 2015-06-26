# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "cleverbot"
  s.version = "0.2.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Benjamin Manns"]
  s.date = "2013-09-06"
  s.description = "Ruby wrapper for Cleverbot."
  s.email = "benmanns@gmail.com"
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.rdoc"
  ]
  s.files = `git ls-files -z`.split("\x0")
  s.homepage = "https://github.com/benmanns/cleverbot"
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = "2.0.6"
  s.summary = s.description

  s.add_dependency "hashie"
  s.add_dependency "httparty", ["< 1.0", ">= 0.8.1"]

  s.add_development_dependency "bundler"
  s.add_development_dependency "jeweler"
  s.add_development_dependency "pry"
  s.add_development_dependency "rake"
  s.add_development_dependency "rdoc"
  s.add_development_dependency "rspec"
  s.add_development_dependency "simplecov"
  s.add_development_dependency "vcr"
  s.add_development_dependency "webmock"
end
