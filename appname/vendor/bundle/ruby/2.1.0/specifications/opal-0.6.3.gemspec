# -*- encoding: utf-8 -*-
# stub: opal 0.6.3 ruby lib

Gem::Specification.new do |s|
  s.name = "opal"
  s.version = "0.6.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Adam Beynon"]
  s.date = "2014-11-23"
  s.description = "Ruby runtime and core library for javascript."
  s.email = "adam.beynon@gmail.com"
  s.executables = ["opal", "opal-build", "opal-repl"]
  s.files = ["bin/opal", "bin/opal-build", "bin/opal-repl"]
  s.homepage = "http://opalrb.org"
  s.licenses = ["MIT"]
  s.rubygems_version = "2.2.2"
  s.summary = "Ruby runtime and core library for javascript"

  s.installed_by_version = "2.2.2" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<source_map>, [">= 0"])
      s.add_runtime_dependency(%q<sprockets>, [">= 0"])
      s.add_development_dependency(%q<mspec>, ["= 1.5.20"])
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<racc>, [">= 0"])
      s.add_development_dependency(%q<rspec>, ["~> 2.14"])
      s.add_development_dependency(%q<octokit>, ["~> 2.4.0"])
      s.add_development_dependency(%q<bundler>, ["~> 1.6"])
      s.add_development_dependency(%q<yard>, [">= 0"])
    else
      s.add_dependency(%q<source_map>, [">= 0"])
      s.add_dependency(%q<sprockets>, [">= 0"])
      s.add_dependency(%q<mspec>, ["= 1.5.20"])
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<racc>, [">= 0"])
      s.add_dependency(%q<rspec>, ["~> 2.14"])
      s.add_dependency(%q<octokit>, ["~> 2.4.0"])
      s.add_dependency(%q<bundler>, ["~> 1.6"])
      s.add_dependency(%q<yard>, [">= 0"])
    end
  else
    s.add_dependency(%q<source_map>, [">= 0"])
    s.add_dependency(%q<sprockets>, [">= 0"])
    s.add_dependency(%q<mspec>, ["= 1.5.20"])
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<racc>, [">= 0"])
    s.add_dependency(%q<rspec>, ["~> 2.14"])
    s.add_dependency(%q<octokit>, ["~> 2.4.0"])
    s.add_dependency(%q<bundler>, ["~> 1.6"])
    s.add_dependency(%q<yard>, [">= 0"])
  end
end
