# -*- encoding: utf-8 -*-
# stub: volt-progress-bar 0.0.1 ruby lib

Gem::Specification.new do |s|
  s.name = "volt-progress-bar"
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Corey"]
  s.date = "2014-01-31"
  s.description = "This is a simple progress bar component for Volt.  The progress bar updates dynamically with a Volt reactive value."
  s.email = ["coreystout@gmail.com"]
  s.homepage = ""
  s.licenses = ["MIT"]
  s.rubygems_version = "2.2.2"
  s.summary = "A simple progress bar."

  s.installed_by_version = "2.2.2" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<volt>, ["~> 0.3.0"])
      s.add_development_dependency(%q<rake>, [">= 0"])
    else
      s.add_dependency(%q<volt>, ["~> 0.3.0"])
      s.add_dependency(%q<rake>, [">= 0"])
    end
  else
    s.add_dependency(%q<volt>, ["~> 0.3.0"])
    s.add_dependency(%q<rake>, [">= 0"])
  end
end
