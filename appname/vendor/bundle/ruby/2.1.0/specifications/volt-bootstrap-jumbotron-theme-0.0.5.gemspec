# -*- encoding: utf-8 -*-
# stub: volt-bootstrap-jumbotron-theme 0.0.5 ruby lib

Gem::Specification.new do |s|
  s.name = "volt-bootstrap-jumbotron-theme"
  s.version = "0.0.5"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Ryan Stout"]
  s.date = "2015-02-11"
  s.email = ["ryanstout@gmail.com"]
  s.homepage = ""
  s.licenses = ["MIT"]
  s.rubygems_version = "2.2.2"
  s.summary = "Basic jumbotron theme for volt when using bootstrap"

  s.installed_by_version = "2.2.2" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<volt>, ["~> 0.5.0"])
      s.add_development_dependency(%q<rake>, [">= 0"])
    else
      s.add_dependency(%q<volt>, ["~> 0.5.0"])
      s.add_dependency(%q<rake>, [">= 0"])
    end
  else
    s.add_dependency(%q<volt>, ["~> 0.5.0"])
    s.add_dependency(%q<rake>, [">= 0"])
  end
end
