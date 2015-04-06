# encoding: utf-8

require "sockjs/session"
require "sockjs/servers/request"
require "sockjs/servers/response"

require 'rack/mount'

module SockJS
  class SessionUnavailableError < StandardError
  end

  #If I had it to do over again, Endpoint wouldn't have subclasses - we'd
  #subclass Response and instances of Endpoint would know what kind of Response
  #to create for their mount point
  class Endpoint
    class MethodMap
      def initialize(map)
        @method_map = map
      end
      attr_reader :method_map

      def call(env)
        app = @method_map.fetch(env["REQUEST_METHOD"])
        app.call(env)
      rescue KeyError
        ::SockJS.debug "Method not supported!"
        [405, {"Allow" => methods_map.keys.join(", ") }, []]
      end
    end

    class MethodNotSupportedApp
      def initialize(methods)
        @allowed_methods = methods
      end

      def response
        ::SockJS.debug "Method not supported! (app)"
        @response ||=
          [405, {"Allow" => @allowed_methods.join(",")}, []].freeze
      end

      def call(env)
        return response
      end
    end

    #XXX Remove
    # @deprecated: See response.rb
    CONTENT_TYPES ||= {
      plain: "text/plain; charset=UTF-8",
      html: "text/html; charset=UTF-8",
      javascript: "application/javascript; charset=UTF-8",
      event_stream: "text/event-stream; charset=UTF-8"
    }

    module ClassMethods
      def add_routes(route_set, connection, options)
        method_catching = Hash.new{|h,k| h[k] = []}
        endpoints.each do |endpoint_class|
          endpoint_class.add_route(route_set, connection, options)
          method_catching[endpoint_class.routing_prefix] << endpoint_class.method
        end
        method_catching.each_pair do |prefix, methods|
          route_set.add_route(MethodNotSupportedApp.new(methods), {:path_info => prefix}, {})
        end
      end

      def routing_prefix
        case prefix
        when String
          "/" + prefix
        when Regexp
          prefix
        end
      end

      def route_conditions
        {
          :request_method => self.method,
          :path_info => self.routing_prefix
        }
      end

      def add_route(route_set, connection, options)
        #SockJS.debug "Adding route for #{self} on #{route_conditions.inspect}"
        route_set.add_route(self.new(connection, options), route_conditions, {})
      end

      def endpoints
        @endpoints ||= []
      end

      def register(method, prefix)
        @prefix = prefix
        @method = method
        Endpoint.endpoints << self
      end
      attr_reader :prefix, :method
    end
    extend ClassMethods

    # Instance methods.
    attr_reader :connection, :options
    def initialize(connection, options)
      @connection, @options = connection, options
      options[:websocket] = true unless options.has_key?(:websocket)
      options[:cookie_needed] = true unless options.has_key?(:cookie_needed)
    end

    def inspect
      "<<#{self.class.name} #{options.inspect}>>"
    end

    def response_class
      SockJS::Response
    end

    # Used for pings.
    def empty_string
      "\n"
    end

    def format_frame(session, payload)
      raise TypeError.new("Payload must not be nil!") if payload.nil?

      "#{payload}\n"
    end

    attr_reader :remote_addr, :http_origin
    def call(env)
      @remote_addr = env["REMOTE_ADDR"]
      @http_origin = env["HTTP_ORIGIN"]
      SockJS.debug "Request for #{self.class}: #{env["REQUEST_METHOD"]}/#{env["PATH_INFO"]}"
      request = ::SockJS::Request.new(env)
      EM.next_tick do
        handle(request)
      end
      return Thin::Connection::AsyncResponse
    end

    def handle(request)
      handle_request(request)
    rescue SockJS::HttpError => error
      SockJS.debug "HttpError while handling request: #{([error.inspect] + error.backtrace).join("\n")}"
      handle_http_error(request, error)
    rescue Object => error
      SockJS.debug "Error while handling request: #{([error.inspect] + error.backtrace).join("\n")}"
      begin
        response = response_class.new(request, 500)
        response.write(error.message)
        response.finish
        return response
      rescue Object => ex
        SockJS.debug "Error while trying to send error HTTP response: #{ex.inspect}"
      end
    end

    def handle_request(request)
      response = build_response(request)
      response.finish
      return response
    end

    def error_content_type
      :plain
    end

    def handle_http_error(request, error)
      response = build_error_response(request)
      response.status = error.status

      response.set_content_type(error_content_type)
      SockJS::debug "Built error response: #{response.inspect}"
      response.write(error.message)
      response
    end

    def build_response(request)
      response = response_class.new(request)
      setup_response(request, response)
      return response
    end

    def build_error_response(request)
      build_response(request)
    end

    def setup_response(request, response)
      response.status = 200
    end
  end

  class SessionEndpoint < Endpoint
    def self.routing_prefix
      legal_key_regexp = %r{[^./]+}
      ::Rack::Mount::Strexp.new("/:server_key/:session_key/#{self.prefix}", {:server_key => legal_key_regexp, :session_key => legal_key_regexp})
    end
  end

  class Transport < SessionEndpoint
    def handle_request(request)
      SockJS::debug({:Request => request, :Transport => self}.inspect)

      response = build_response(request)
      session = get_session(response)

      process_session(session, response)

      return response
    rescue SockJS::InvalidJSON => error
      exception_response(request, error, 500)
    rescue SockJS::SessionUnavailableError => error
      handle_session_unavailable(request)
    end

    def response_beginning(response)
    end

    def exception_response(request, error, status)
      SockJS::debug("Handling error #{error.inspect}")
      response = build_response(request)
      response.status = status
      response.set_content_type(:plain)
      response.set_session_id(request.session_id)
      response.write(error.message)
      SockJS::debug("Error response: #{response.inspect}")
      return response
    end

    def handle_session_unavailable(request)
      SockJS::debug("Handling missing session for #{request.inspect}")
      response = build_response(request)
      response.status = 404
      response.set_content_type(:plain)
      response.set_session_id(request.session_id)
      response.write("Session is not open!")
      return response
    end

    def server_key(response)
      request = response.request
      (request.env['rack.routing_args'] || {})[:server_key]
    end

    def session_key(response)
      request = response.request
      (request.env['rack.routing_args'] || {})[:session_key]
    end

    def request_data(request)
      request.data.string
    end
  end

  class ConsumingTransport < Transport
    def process_session(session, response)
      session.attach_consumer(response, self)
      response.request.on_close do
        begin
          request_closed(session)
        rescue Object => ex
          SockJS::debug "Exception when closing request: #{ex.inspect}"
        end
      end
    end

    def request_closed(session)
      session.detach_consumer
    end

    def finish_response(response)
      response.finish
    end

    def opening_frame(response)
      send_data(response, format_frame(response, Protocol::OpeningFrame.instance))
    end

    def heartbeat_frame(response)
      send_data(response, format_frame(response, Protocol::HeartbeatFrame.instance))
    end

    def messages_frame(response, messages)
      send_data(response, format_frame(response, Protocol::ArrayFrame.new(messages)))
    end

    def closing_frame(response, status, message)
      send_data(response, format_frame(response, Protocol::ClosingFrame.new(status, message)))
      finish_response(response)
    end

    #TODO: Consider absorbing format_frame into send_data
    def send_data(response, data)
      response.write(data)
      return data.length
    end

    def format_frame(response, frame)
      frame.to_s + "\n"
    end

    def get_session(response)
      begin
        session = connection.get_session(session_key(response))
        response_beginning(response)
        return session
      rescue KeyError
        SockJS::debug("Missing session for #{session_key(response)} - creating new")
        session = connection.create_session(session_key(response))
        response_beginning(response)
        opening_frame(response)
        return session
      end
    end
  end

  class PollingConsumingTransport < ConsumingTransport
    def process_session(session, response)
      super
      #response.finish
    end
  end

  class DeliveryTransport < Transport
    def process_session(session, response)
      session.receive_message(extract_message(response.request))

      successful_response(response)
    end

    def extract_message(request)
      body = request.data.read
      raise "Payload expected." if body.empty?
      return body
    end

    def setup_response(response)
      response.status = 204
    end

    def successful_response(response)
      response.finish
    end

    def get_session(response)
      begin
        session = connection.get_session(session_key(response))
        response_beginning(response)
        return session
      rescue KeyError
        SockJS::debug("Missing session for #{session_key(response)} - invalid request")
        raise SessionUnavailableError
      end
    end
  end
end
