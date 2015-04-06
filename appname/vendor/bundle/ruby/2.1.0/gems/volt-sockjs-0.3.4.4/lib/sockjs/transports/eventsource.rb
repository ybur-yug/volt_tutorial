# encoding: utf-8

require "sockjs/transport"

module SockJS
  module Transports
    class EventSource < ConsumingTransport
      register 'GET', 'eventsource'

      def setup_response(request, response)
        response.status = 200

        response.set_content_type(:event_stream)
        response.set_session_id(request.session_id)
        response.set_no_cache
        response.write_head

        # Opera needs to hear two more initial new lines.
        response.write("\r\n")
        response
      end

      def format_frame(response, frame)
        raise TypeError.new("Payload must not be nil!") if frame.nil?

        ["data: ", frame.to_s, "\r\n\r\n"].join
      end
    end
  end
end
