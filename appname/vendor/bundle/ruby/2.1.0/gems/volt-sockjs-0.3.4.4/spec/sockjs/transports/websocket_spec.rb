#!/usr/bin/env bundle exec rspec
# encoding: utf-8

require "spec_helper"

require "sockjs"
require "sockjs/transports/websocket"

describe SockJS::Transports::WebSocket, :type => :transport do
  transport_handler_eql "/websocket", "GET"

  let :request_options do
    {}
  end

  let :request do
    env = {
      "HTTP_CONNECTION" => "Upgrade",
      "HTTP_UPGRADE" => "WebSocket"}
    FakeRequest.new(env.merge(request_options)).tap do |request|
      request.path_info = "/a/b/websocket"
    end
  end

  describe "#handle(request)" do
    context "if the transport is disabled" do
      let :transport_options do
        {:websocket => false}
      end

      it "should report itself disabled" do
        transport.should be_disabled
      end

      it "should respond with 404 and an error message" do
        response.status.should eql(404)
        response.chunks.last.should eql("WebSockets Are Disabled")
      end
    end

    context "if HTTP_UPGRADE isn't WebSocket" do
      let :request_options do
        { "HTTP_UPGRADE" => "something" }
      end

      it "should respond with 400 and an error message" do
        response.status.should eql(400)
        response.chunks.last.should eql('Can "Upgrade" only to "WebSocket".')
      end
    end


    context "if HTTP_CONNECTION isn't Upgrade" do
      let :request_options do
        {"HTTP_CONNECTION" => "something"}
      end

      it "should respond with 400 and an error message" do
        response.status.should eql(400)
        response.chunks.last.should eql('"Connection" must be "Upgrade".')
      end
    end

    # The following three statements are meant to be documentation rather than specs itselves.
    it "should call #handle_open(request) when the connection is being open"

    it "should call #handle_message(request, event) on a new message"

    it "should call #handle_close(request, event) when the connection is being closed"
  end

  describe "#handle_open(request)" do
    it "should send the opening frame"
    it "should open a new session"
  end

  describe "#handle_message(request, event)" do
    let(:app) do
      Proc.new do |connection|
        connection.subscribe do |session, message|
          session.send(message.upcase)
        end
      end
    end

    it "should receive the message"
    it "should run user code"
    it "should send messages"
  end

  describe "#handle_close(request, event)" do
    it "should send the closing frame"
    it "should open a new session"
  end

  describe "#send" do
    it "should be defined, but it should do nothing" do
      transport.should respond_to(:send)
    end
  end
end
