require 'thin'
require 'rack/sockjs'
require 'rack/builder'

module SockJS
  module Examples
    class ProtocolConformanceTest
      class MyHelloWorld
        BODY = [<<-HTML].freeze
<html>
  <head>
    <title>Hello World!</title>
  </head>

  <body>
    <h1>Hello World!</h1>
    <p>
      This is the app, not SockJS.
    </p>
  </body>
</html>
        HTML

        def call(env)
          [200, {"Content-Type" => "text/html; charset=UTF-8", "Content-Length" => BODY.join("").bytesize.to_s}, BODY]
        end
      end

      def self.build_app(*args)
        self.new(*args).to_app
      end

      def initialize(options = nil)
        @options = options || {}
      end

      attr_accessor :options

      class EchoSession < Session
        def process_message(message)
          SockJS.debug "\033[0;31;40m[Echo]\033[0m message: #{message.inspect}, session: #{self.object_id}"
          send(message)
        end
      end

      class CloseSession < Session
        def opened
          SockJS.debug "\033[0;31;40m[Close]\033[0m closing the session ..."
          close(3000, "Go away!")
        end
      end

      def to_app
        options = self.options
        ::Rack::Builder.new do
          map '/echo' do
            run ::Rack::SockJS.new(EchoSession, options)
          end

          map '/disabled_websocket_echo' do
            run ::Rack::SockJS.new(EchoSession, options.merge(:websocket => false))
          end

          map '/close' do
            run ::Rack::SockJS.new(CloseSession, options)
          end

          run MyHelloWorld.new
        end.to_app
      end
    end
  end
end
