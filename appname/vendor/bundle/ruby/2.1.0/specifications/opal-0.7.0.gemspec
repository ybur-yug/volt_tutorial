# -*- encoding: utf-8 -*-
# stub: opal 0.7.0 ruby lib

Gem::Specification.new do |s|
  s.name = "opal"
  s.version = "0.7.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Adam Beynon"]
  s.date = "2015-02-01"
  s.description = "Ruby runtime and core library for javascript."
  s.email = "adam.beynon@gmail.com"
  s.executables = ["opal", "opal-build", "opal-mspec", "opal-repl"]
  s.files = ["bin/opal", "bin/opal-build", "bin/opal-mspec", "bin/opal-repl"]
  s.homepage = "http://opalrb.org"
  s.licenses = ["MIT"]
  s.rubygems_version = "2.2.2"
  s.summary = "Ruby runtime and core library for javascript"

  s.installed_by_version = "2.2.2" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<sourcemap>, ["~> 0.1.0"])
      s.add_runtime_dependency(%q<sprockets>, ["< 4.0.0", ">= 2.2.3"])
      s.add_runtime_dependency(%q<hike>, ["~> 1.2"])
      s.add_runtime_dependency(%q<tilt>, ["~> 1.4"])
      s.add_development_dependency(%q<mspec>, ["= 1.5.20"])
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<racc>, [">= 0"])
      s.add_development_dependency(%q<rspec>, ["~> 2.99"])
      s.add_development_dependency(%q<octokit>, ["~> 2.4.0"])
      s.add_development_dependency(%q<bundler>, ["~> 1.5"])
      s.add_development_dependency(%q<yard>, ["~> 0.8.7"])
      s.add_development_dependency(%q<rack-test>, [">= 0"])
      s.add_development_dependency(%q<opal-minitest>, [">= 0"])
    else
      s.add_dependency(%q<sourcemap>, ["~> 0.1.0"])
      s.add_dependency(%q<sprockets>, ["< 4.0.0", ">= 2.2.3"])
      s.add_dependency(%q<hike>, ["~> 1.2"])
      s.add_dependency(%q<tilt>, ["~> 1.4"])
      s.add_dependency(%q<mspec>, ["= 1.5.20"])
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<racc>, [">= 0"])
      s.add_dependency(%q<rspec>, ["~> 2.99"])
      s.add_dependency(%q<octokit>, ["~> 2.4.0"])
      s.add_dependency(%q<bundler>, ["~> 1.5"])
      s.add_dependency(%q<yard>, ["~> 0.8.7"])
      s.add_dependency(%q<rack-test>, [">= 0"])
      s.add_dependency(%q<opal-minitest>, [">= 0"])
    end
  else
    s.add_dependency(%q<sourcemap>, ["~> 0.1.0"])
    s.add_dependency(%q<sprockets>, ["< 4.0.0", ">= 2.2.3"])
    s.add_dependency(%q<hike>, ["~> 1.2"])
    s.add_dependency(%q<tilt>, ["~> 1.4"])
    s.add_dependency(%q<mspec>, ["= 1.5.20"])
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<racc>, [">= 0"])
    s.add_dependency(%q<rspec>, ["~> 2.99"])
    s.add_dependency(%q<octokit>, ["~> 2.4.0"])
    s.add_dependency(%q<bundler>, ["~> 1.5"])
    s.add_dependency(%q<yard>, ["~> 0.8.7"])
    s.add_dependency(%q<rack-test>, [">= 0"])
    s.add_dependency(%q<opal-minitest>, [">= 0"])
  end
end
