# -*- encoding: utf-8 -*-
# stub: opal-rspec 0.4.0 ruby lib

Gem::Specification.new do |s|
  s.name = "opal-rspec"
  s.version = "0.4.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Adam Beynon"]
  s.date = "2015-02-02"
  s.description = "Opal compatible rspec library"
  s.email = "adam.beynon@gmail.com"
  s.homepage = "http://opalrb.org"
  s.rubygems_version = "2.2.2"
  s.summary = "RSpec for Opal"

  s.installed_by_version = "2.2.2" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<opal>, ["= 0.7.0"])
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<yard>, [">= 0"])
    else
      s.add_dependency(%q<opal>, ["= 0.7.0"])
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<yard>, [">= 0"])
    end
  else
    s.add_dependency(%q<opal>, ["= 0.7.0"])
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<yard>, [">= 0"])
  end
end
