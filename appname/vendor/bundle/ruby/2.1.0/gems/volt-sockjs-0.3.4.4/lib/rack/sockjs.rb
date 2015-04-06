# encoding: utf-8
require "sockjs"
require 'sockjs/version'
require "sockjs/transport"
require "sockjs/servers/request"
require "sockjs/servers/response"

require 'rack/mount'

require 'sockjs/duck-punch-rack-mount'
require 'sockjs/duck-punch-thin-response'

# Transports.
require "sockjs/transports/info"
require "sockjs/transports/eventsource"
require "sockjs/transports/htmlfile"
require "sockjs/transports/iframe"
require "sockjs/transports/jsonp"
require "sockjs/transports/websocket"
require "sockjs/transports/welcome_screen"
require "sockjs/transports/xhr"

# This is a Rack middleware for SockJS.
#
#@example
#
#  require 'rack/sockjs'
#
#  map "/echo", Rack::SockJS.new do |connection|
#    connection.subscribe do |session, message|
#      session.send(message)
#    end
#  end
#
#  run MyApp
#
#
# #or
#
#  run Rack::SockJS.new do |connection|
#    connection.session_open do |session|
#      session.close(3000, "Go away!")
#    end
#  end

module Rack
  class SockJS
    SERVER_SESSION_REGEXP = %r{/([^/]*)/([^/]*)}
    DEFAULT_OPTIONS = {
      :sockjs_url => "http://cdn.sockjs.org/sockjs-#{::SockJS::PROTOCOL_VERSION_STRING}.min.js"
    }


    class DebugRequest
      def initialize(app)
        @app = app
      end

      def call(env)
        request = ::SockJS::Request.new(env)
        headers = request.headers.select { |key, value| not %w{version host accept-encoding}.include?(key.to_s) }
        ::SockJS.puts "\n~ \e[31m#{request.http_method} \e[32m#{request.path_info.inspect}#{" " + headers.inspect unless headers.empty?} \e[0m(\e[34m#{@prefix} app\e[0m)"
        headers = headers.map { |key, value| "-H '#{key}: #{value}'" }.join(" ")
        ::SockJS.puts "\e[90mcurl -X #{request.http_method} http://localhost:8081#{request.path_info} #{headers}\e[0m"

        result = @app.call(env)
      ensure
        ::SockJS.debug "Rack response: " + result.inspect
      end
    end

    class MissingHandler
      def initialize(options)
      end

      def call(env)
        prefix = env["PATH_INFO"]
        method = env["REQUEST_METHOD"]
        body = <<-HTML
          <!DOCTYPE html>
          <html>
            <body>
              <h1>Handler Not Found</h1>
              <ul>
                <li>Prefix: #{prefix.inspect}</li>
                <li>Method: #{method.inspect}</li>
              </ul>
            </body>
          </html>
        HTML
        ::SockJS.debug "Handler not found!"
        [404, {"Content-Type" => "text/html; charset=UTF-8", "Content-Length" => body.bytesize.to_s}, [body]]
      end
    end

    class ResetScriptName
      def initialize(app)
        @app = app
      end

      def call(env)
        env["PREVIOUS_SCRIPT_NAME"], env["SCRIPT_NAME"] = env["SCRIPT_NAME"], ''
        result = @app.call(env)
      ensure
        env["SCRIPT_NAME"] = env["PREVIOUS_SCRIPT_NAME"]
      end
    end

    class RenderErrors
      def initialize(app)
        @app = app
      end

      def call(env)
        return @app.call(env)
      rescue => err
        if err.respond_to? :to_html
          err.to_html
        else
          raise
        end
      end
    end

    class ExtractServerAndSession
      def initialize(app)
        @app = app
      end

      def call(env)
        match = SERVER_SESSION_REGEXP.match(env["SCRIPT_NAME"])
        env["sockjs.server-id"] = match[1]
        env["sockjs.session-key"] = match[2]
        old_script_name, old_path_name = env["SCRIPT_NAME"], env["PATH_INFO"]
        env["SCRIPT_NAME"] = env["SCRIPT_NAME"] + match[0]
        env["PATH_INFO"] = match.post_match

        return @app.call(env)
      ensure
        env["SCRIPT_NAME"], env["PATH_INFO"] = old_script_name, old_path_name
      end
    end

    def initialize(session_class, options = nil)
      #TODO refactor Connection to App
      connection = ::SockJS::Connection.new(session_class, options)

      options ||= {}

      options = DEFAULT_OPTIONS.merge(options)

      @routing = Rack::Mount::RouteSet.new do |set|
        ::SockJS::Endpoint.add_routes(set, connection, options)

        set.add_route(MissingHandler.new(options), {}, {}, :missing)
      end

      routing = @routing

      @app = Rack::Builder.new do
        use Rack::SockJS::ResetScriptName
        use DebugRequest
        run routing
      end.to_app
    end

    attr_reader :routing

    def call(env)
      @app.call(env)
    end
  end
end
