# encoding: utf-8

require "sockjs/transport"

module SockJS
  module Transports
    class XHROptions < SessionEndpoint
      register 'OPTIONS', 'xhr'

      def setup_response(request, response)
        response.status = 204
        response.set_allow_options_post
        response.set_cache_control
        response.set_access_control(request.origin)
        response.set_session_id(request.session_id)
      end
    end

    class XHRSendOptions < XHROptions
      register 'OPTIONS', 'xhr_send'
    end

    class XHRStreamingOptions < XHROptions
      register 'OPTIONS', 'xhr_streaming'
    end

    class XHRSendPost < DeliveryTransport
      register 'POST', 'xhr_send'

      def setup_response(request, response)
        response.status = 204

        response.set_content_type(:plain)
        response.set_access_control(request.origin)
        response.set_session_id(request.session_id)
        response
      end
    end

    class XHRPost < PollingConsumingTransport
      register 'POST', 'xhr'

      def setup_response(request, response)
        response.status = 200
        response.set_content_type(:javascript)
        response.set_access_control(request.origin)
        response.set_session_id(request.session_id)
        response
      end
    end

    class XHRStreamingPost < ConsumingTransport
      PREAMBLE ||= "h" * 2048 + "\n"

      register 'POST', 'xhr_streaming'

      def setup_response(request, response)
        response.status = 200
        response.set_content_type(:javascript)
        response.set_access_control(request.origin)
        response.set_session_id(request.session_id)
      end

      def response_beginning(response)
        response.write_head
        response.write(PREAMBLE)
      end

      def handle_session_unavailable(error, response)
        response.write(PREAMBLE)
        super(error, response)
      end
    end
  end
end
