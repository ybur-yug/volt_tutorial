# encoding: utf-8

require 'support/async-test.rb'
require 'support/shared-contexts'
require 'stringio'
require 'thin'
require 'sockjs'
require 'sockjs/servers/request'
require 'sockjs/servers/response'
require 'sockjs/session'

require 'sockjs/examples/protocol_conformance_test'
require 'sockjs/version'

module TransportSpecMacros
  def transport_handler_eql(path, method)
    describe SockJS::Transport do
      describe "transports[#{path}]" do
        let :route_set do
          mock("Route Set")
        end

        let :connection do
          mock("Connection")
        end

        let :options do
          {}
        end

        let :path_matcher do

        end

        it "should have a #{described_class} at #{method}" do
          route_set.should_receive(:add_route).with(instance_of(described_class), hash_including(:path_info, :request_method => method), {})
          described_class.add_route(route_set, connection, options)
        end
      end
    end
  end
end

class FakeRequest < SockJS::Request
  attr_reader :chunks
  attr_writer :data
  attr_accessor :path_info, :query_string, :if_none_match, :content_type

  def initialize(env = Hash.new)
    self.env.merge!(env)
    @query_string = {}
    @chunks = []
  end

  def session_key=(value)
    @env['rack.routing_args'] ||= {}
    @env['rack.routing_args'][:session_key] = value
  end

  def env
    @env ||= {
      "async.callback" => Proc.new do |status, headers, body|
        # This is so we can test it.
        # Block passed to body.each will be used
        # as the @body_callback in DelayedResponseBody.
        body.each do |chunk|
          next if chunk == "0\r\n\r\n"
          @chunks << chunk.split("\r\n").last
        end
      end,

      "async.close" => EventMachine::DefaultDeferrable.new
    }
  end

  def session_id
    "session-id"
  end

  def origin
    "*"
  end

  def fresh?(etag)
    @if_none_match == etag
  end

  def data
    StringIO.new(@data || "")
  end
end

class FakeSession < SockJS::Session
  def set_timer
  end

  def reset_timer
  end
end

class SockJS::Response
  def chunks
    @request.chunks
  end
end

RSpec.configure do |config|
  config.backtrace_clean_patterns.delete(/gems/)
  config.extend(TransportSpecMacros)
  config.before do
    class SockJS::Transport
      def session_class
        FakeSession
      end
    end
  end

  config.after do
    SockJS::no_debug!
  end
end
