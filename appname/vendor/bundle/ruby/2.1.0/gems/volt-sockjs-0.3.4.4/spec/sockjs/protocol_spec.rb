#!/usr/bin/env bundle exec rspec
# encoding: utf-8

require "spec_helper"
require "sockjs/protocol"

describe SockJS::Protocol do
  it "OpeningFrame should be 'o'" do
    described_class::OpeningFrame.instance.to_s.should eql("o")
  end

  it "HeartbeatFrame should be 'h'" do
    described_class::HeartbeatFrame.instance.to_s.should eql("h")
  end

  describe "ArrayFrame" do
    it "should take only an array as the first argument" do
      expect {
        SockJS::Protocol::ArrayFrame.new(Hash.new)
      }.to raise_error(TypeError)
    end

    it "should return a valid array frame" do
      SockJS::Protocol::ArrayFrame.new([1, 2, 3]).to_s.should eql("a[1,2,3]")
      SockJS::Protocol::ArrayFrame.new(["tests"]).to_s.should eql('a["tests"]')
    end
  end

  describe "ClosingFrame" do
    it "should take only integer as the first argument" do
      expect {
        SockJS::Protocol::ClosingFrame.new("2010", "message")
      }.to raise_error(TypeError)
    end

    it "should take only string as the second argument" do
      expect {
        SockJS::Protocol::ClosingFrame.new(2010, :message)
      }.to raise_error(TypeError)
    end

    it "should return a valid closing frame" do
      expect {
        frame = SockJS::Protocol::ClosingFrame.new(2010, "message")
        frame.to_s.should eql('c[2010,"message"]')
      }.not_to raise_error
    end
  end
end
