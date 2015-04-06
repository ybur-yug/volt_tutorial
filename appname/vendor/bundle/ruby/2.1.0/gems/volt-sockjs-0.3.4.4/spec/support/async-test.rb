require 'thin'
require 'eventmachine'

module Thin
  module Async
    class Test
      VERSION = '1.0.0'

      class Callback
        attr_reader :status, :headers, :body

        def call args
          @status, @headers, deferred_body = args
          @body = ""
          deferred_body.each {|s| @body << s }

          deferred_body.callback { EM.stop }
        end
      end

      def initialize(app, options={})
        @app = app
      end

      def call(env)
        callback = Callback.new
        env.merge! 'async.callback' => callback

        result = @app.call(env)

        unless result.first == -1
          EM.next_tick do
            EM.stop
            return result
          end
        end

        [callback.status, callback.headers, callback.body]
      end
    end
  end
end
