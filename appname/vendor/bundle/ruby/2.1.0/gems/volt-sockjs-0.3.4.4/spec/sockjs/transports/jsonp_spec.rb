#!/usr/bin/env bundle exec rspec
# encoding: utf-8

require "spec_helper"

require "sockjs"
require "sockjs/transports/jsonp"

describe "JSONP", :em => true, :type => :transport do
  let(:open_request) do
    FakeRequest.new.tap do |request|
      request.path_info = "/jsonp"
      request.query_string = {"c" => "clbk"}
      request.data = "ok"
      request.session_key = "b"
    end
  end

  describe SockJS::Transports::JSONP do
    transport_handler_eql "/jsonp", "GET"

    describe "#handle(request)" do
      let(:request) do
        FakeRequest.new.tap do |request|
          request.path_info = "/echo/a/b/jsonp"
        end
      end

      context "with callback specified" do
        let(:request) do
          FakeRequest.new.tap do |request|
            request.path_info = "/jsonp"
            request.query_string = {"c" => "clbk"}
            request.session_key = "b"
          end
        end

        context "with a session" do
          let(:prior_transport) do
            described_class.new(connection, {})
          end

          it "should respond with HTTP 200" do
            response.status.should eql(200)
          end

          it "should respond with plain text MIME type" do
            response.headers["Content-Type"].should match("application/javascript")
          end

          it "should respond with a body"
        end

        context "without any session" do
          it "should respond with HTTP 200" do
            response.status.should eql(200)
          end

          it "should respond with javascript MIME type" do
            response.headers["Content-Type"].should match("application/javascript")
          end

          it "should set access control" do
            response.headers["Access-Control-Allow-Origin"].should eql(request.origin)
            response.headers["Access-Control-Allow-Credentials"].should eql("true")
          end

          it "should disable caching" do
            response.headers["Cache-Control"].should eql("no-store, no-cache, must-revalidate, max-age=0")
          end

          it "should open a new session"
        end
      end

      context "without callback specified" do
        it "should respond with HTTP 500" do
          response.status.should eql(500)
        end

        it "should respond with HTML MIME type" do
          response.headers["Content-Type"].should match("text/html")
        end

        it "should return error message in the body" do
          response.chunks.last.should match(/"callback" parameter required/)
        end
      end
    end

    describe "#format_frame(payload)" do
      it "should format payload"
    end
  end

  describe SockJS::Transports::JSONPSend do
    transport_handler_eql "/jsonp_send", "POST"

    describe "#handle(request)" do
      let(:request) do
        FakeRequest.new.tap do |request|
          request.path_info = "/a/_/jsonp_send"
        end
      end

      context "with valid data" do
        context "with application/x-www-form-urlencoded" do
          # TODO: test with invalid data like d=sth, we should get Broken encoding.
          context "with a valid session" do
            before :each do
              session
            end

            let(:request) do
              FakeRequest.new.tap do |request|
                request.path_info = "/jsonp_send"
                request.session_key = existing_session_key
                request.content_type = "application/x-www-form-urlencoded"
                request.data = "d=%5B%22x%22%5D"
              end
            end

            it "should respond with HTTP 200" do
              response.status.should eql(200)
            end

            it "should set session ID" do
              cookie = response.headers["Set-Cookie"]
              cookie.should match("JSESSIONID=#{request.session_id}; path=/")
            end

            it "should write 'ok' to the body stream" do
              response # Run the handler.
              response.chunks.last.should eql("ok")
            end
          end

          context "without a valid session" do
            let :session do
            end

            let(:request) do
              FakeRequest.new.tap do |request|
                request.path_info = "/a/_/jsonp_send"
                request.content_type = "application/x-www-form-urlencoded"
                request.data = "d=sth"
              end
            end

            it "should respond with HTTP 404" do
              SockJS::debug!
              response.status.should eql(404)
            end

            it "should respond with plain text MIME type" do
              response.headers["Content-Type"].should match("text/plain")
            end

            it "should return error message in the body" do
              response # Run the handler.
              response.chunks.last.should match(/Session is not open\!/)
            end
          end
        end

        context "with any other MIME type" do
          context "with a valid session" do
            before :each do
              session
            end

            let(:request) do
              FakeRequest.new.tap do |request|
                request.path_info = "/jsonp_send"
                request.data = '["data"]'
                request.session_key = existing_session_key
              end
            end

            it "should respond with HTTP 200" do
              response.status.should eql(200)
            end

            it "should set session ID" do
              cookie = response.headers["Set-Cookie"]
              cookie.should match("JSESSIONID=#{request.session_id}; path=/")
            end

            it "should write 'ok' to the body stream" do
              response # Run the handler.
              response.chunks.last.should eql("ok")
            end
          end

          context "without a valid session" do
            let :session do
            end

            let(:request) do
              FakeRequest.new.tap do |request|
                request.path_info = "/a/_/jsonp_send"
                request.data = "data"
              end
            end

            it "should respond with HTTP 404" do
              response.status.should eql(404)
            end

            it "should respond with plain text MIME type" do
              response.headers["Content-Type"].should match("text/plain")
            end

            it "should return error message in the body" do
              response.chunks.last.should match(/Session is not open\!/)
            end
          end
        end
      end

      [nil, "", "d=", "f=test"].each do |data|
        context "with data = #{data.inspect}" do
          before :each do
            session
          end

          let(:request) do
            FakeRequest.new.tap do |request|
              request.path_info = "/jsonp_send"
              request.session_key = "b"
              request.content_type = "application/x-www-form-urlencoded"
              request.data = data
            end
          end

          it "should respond with HTTP 500" do
            response.status.should eql(500)
          end

          it "should respond with HTML MIME type" do
            response.headers["Content-Type"].should match("text/html")
          end

          it "should return error message in the body" do
            response # Run the handler.
            response.chunks.last.should match(/Payload expected./)
          end
        end
      end
    end
  end
end
