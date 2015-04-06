# -*- encoding: utf-8 -*-
# stub: chromedriver2-helper 0.0.8 ruby lib

Gem::Specification.new do |s|
  s.name = "chromedriver2-helper"
  s.version = "0.0.8"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Mike Dalessio", "Zsolt Sztupak"]
  s.date = "2013-11-11"
  s.description = "Downloads and installs chromedriver2 from google's page and uses it for running the selenium tests. Contains fixes for mac builds, and changes to the google URLs"
  s.email = ["mike@csa.net", "mail@sztupy.hu"]
  s.executables = ["chromedriver", "chromedriver-update"]
  s.files = ["bin/chromedriver", "bin/chromedriver-update"]
  s.homepage = "https://github.com/sztupy/chromedriver-helper"
  s.rubygems_version = "2.2.2"
  s.summary = "Easy installation and use of chromedriver2, the Chromium project's selenium webdriver adapter."

  s.installed_by_version = "2.2.2" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rspec>, [">= 0"])
      s.add_runtime_dependency(%q<nokogiri>, [">= 0"])
    else
      s.add_dependency(%q<rspec>, [">= 0"])
      s.add_dependency(%q<nokogiri>, [">= 0"])
    end
  else
    s.add_dependency(%q<rspec>, [">= 0"])
    s.add_dependency(%q<nokogiri>, [">= 0"])
  end
end
