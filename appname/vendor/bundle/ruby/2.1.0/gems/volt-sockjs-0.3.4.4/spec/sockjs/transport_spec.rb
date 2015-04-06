require "spec_helper"

require "sockjs"
require "sockjs/transport"

describe SockJS::Transport do
  describe "CONTENT_TYPES" do
    [:plain, :html, :javascript, :event_stream].each do |type|
      it "should define #{type}" do
        described_class::CONTENT_TYPES[type].should_not be_nil
      end
    end
  end

  subject do
    described_class.new(Object.new, Hash.new)
  end

  describe "#disabled?", :pending => "valid?" do
    it "should be false if the current class isn't in disabled_transports" do
      subject.should_not be_disabled
    end

    it "should be false if the current class is in disabled_transports" do
      subject.options[:disabled_transports] = [subject.class]
      subject.should be_disabled
    end
  end

  describe "#session_class" do
    it "should be a valid class" do
      subject.session_class.should be_kind_of(Class)
    end
  end

  describe "#response_class" do
    it "should be a valid class" do
      subject.response_class.should be_kind_of(Class)
    end
  end

  let :session do
    mock("Session")
  end

  describe "#format_frame(payload)" do
    it "should fail if payload is nil" do
      expect do
        subject.format_frame(session, nil)
      end.to raise_error(TypeError)
    end

    it "should return payload followed by \\n otherwise" do
      subject.format_frame(session, "o").should eql("o\n")
    end
  end

  describe "#response(request, status)" do
    # TODO
  end

  describe "#respond(request, status, options = Hash.new, &block)" do
    # TODO
  end

  describe "#error(http_status, content_type, body)" do
    # TODO
  end

  describe "#get_session(request, response, preamble = nil)" do
    # TODO
  end
end
