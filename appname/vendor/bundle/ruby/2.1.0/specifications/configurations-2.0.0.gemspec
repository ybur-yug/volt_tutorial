# -*- encoding: utf-8 -*-
# stub: configurations 2.0.0 ruby lib

Gem::Specification.new do |s|
  s.name = "configurations"
  s.version = "2.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Beat Richartz"]
  s.date = "2015-01-07"
  s.description = "Configurations provides a unified approach to do configurations with the flexibility to do everything\n from arbitrary configurations to type asserted configurations for your gem or any other ruby code.\n"
  s.email = "attr_accessor@gmail.com"
  s.homepage = "http://github.com/beatrichartz/configurations"
  s.licenses = ["MIT"]
  s.rubygems_version = "2.2.2"
  s.summary = "Configurations with a configure block from arbitrary to type-restricted for your gem or other ruby code."

  s.installed_by_version = "2.2.2" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<minitest>, ["~> 5.4"])
      s.add_development_dependency(%q<yard>, ["~> 0.8"])
      s.add_development_dependency(%q<rake>, ["~> 10"])
    else
      s.add_dependency(%q<minitest>, ["~> 5.4"])
      s.add_dependency(%q<yard>, ["~> 0.8"])
      s.add_dependency(%q<rake>, ["~> 10"])
    end
  else
    s.add_dependency(%q<minitest>, ["~> 5.4"])
    s.add_dependency(%q<yard>, ["~> 0.8"])
    s.add_dependency(%q<rake>, ["~> 10"])
  end
end
