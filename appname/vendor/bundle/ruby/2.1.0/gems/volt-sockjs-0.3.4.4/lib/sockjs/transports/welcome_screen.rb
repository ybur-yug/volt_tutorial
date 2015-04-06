# encoding: utf-8

require "sockjs/transport"

module SockJS
  module Transports
    class WelcomeScreen < Endpoint
      register 'GET', ''

      def setup_response(request, response)
        response.set_content_type(:plain)
        response.status = 200
        response.write("Welcome to SockJS!\n")
      end
    end
  end
end
