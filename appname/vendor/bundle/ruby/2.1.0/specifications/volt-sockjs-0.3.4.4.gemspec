# -*- encoding: utf-8 -*-
# stub: volt-sockjs 0.3.4.4 ruby lib

Gem::Specification.new do |s|
  s.name = "volt-sockjs"
  s.version = "0.3.4.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Judson Lester"]
  s.date = "2014-04-25"
  s.description = "    SockJS is a WebSocket emulation library. It means that you use the WebSocket API, only instead of WebSocket class you instantiate SockJS class. In absence of WebSocket, some of the fallback transports will be used. This code is compatible with SockJS protocol 0.3.4.\n"
  s.email = "nyarly@gmail.com"
  s.extra_rdoc_files = ["README.textile"]
  s.files = ["README.textile"]
  s.homepage = "https://github.com/voltrb/sockjs-ruby"
  s.required_ruby_version = Gem::Requirement.new(">= 1.9")
  s.rubyforge_project = "sockjs"
  s.rubygems_version = "2.2.2"
  s.summary = "Ruby server for SockJS"

  s.installed_by_version = "2.2.2" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rack>, [">= 0"])
      s.add_runtime_dependency(%q<thin>, [">= 0"])
      s.add_runtime_dependency(%q<json>, [">= 0"])
      s.add_runtime_dependency(%q<faye-websocket>, ["~> 0.7.1"])
      s.add_runtime_dependency(%q<rack-mount>, ["~> 0.8.3"])
    else
      s.add_dependency(%q<rack>, [">= 0"])
      s.add_dependency(%q<thin>, [">= 0"])
      s.add_dependency(%q<json>, [">= 0"])
      s.add_dependency(%q<faye-websocket>, ["~> 0.7.1"])
      s.add_dependency(%q<rack-mount>, ["~> 0.8.3"])
    end
  else
    s.add_dependency(%q<rack>, [">= 0"])
    s.add_dependency(%q<thin>, [">= 0"])
    s.add_dependency(%q<json>, [">= 0"])
    s.add_dependency(%q<faye-websocket>, ["~> 0.7.1"])
    s.add_dependency(%q<rack-mount>, ["~> 0.8.3"])
  end
end
