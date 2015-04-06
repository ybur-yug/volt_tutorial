#!/usr/bin/env bundle exec rspec
# encoding: utf-8

require "spec_helper"

require "sockjs"
require "sockjs/session"
require "sockjs/transports/xhr"

#Comment:
#These specs came to me way to interested in the internals of Session
#Policy has got to be that any spec that fails because e.g. it wants to know
#what state Session is in is a fail.  Okay to spec that Session should be able
#to respond to message X after Y, though.

describe SockJS::Session do
  around :each do |example|
    EM.run do
      example.run
      EM.stop
    end
  end

  let :connection do
    SockJS::Connection.new {}
  end

  let :transport do
    xprt = SockJS::Transports::XHRPost.new(connection, Hash.new)

    def xprt.send
    end

    xprt
  end

  let :request do
    FakeRequest.new.tap do|req|
      req.data = ""
    end
  end

  let :response do
    transport.response_class.new(request, 200)
  end

  let :session do
    sess = described_class.new({:open => []})
    sess
  end
end
