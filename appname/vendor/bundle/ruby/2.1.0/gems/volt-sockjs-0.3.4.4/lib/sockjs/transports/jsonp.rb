# encoding: utf-8

require "sockjs/transport"

module SockJS
  module Transports
    class JSONP < PollingConsumingTransport
      register 'GET', 'jsonp'

      def error_content_type
        :html
      end

      def setup_response(request, response)
        response.status = 200
        response.set_content_type(:javascript)
        response.set_access_control(request.origin)
        response.set_no_cache
        response.set_session_id(request.session_id)
        return response
      end

      def get_session(response)
        if response.request.callback
          super
        else
          raise HttpError.new(500, '"callback" parameter required')
        end
      end

      def format_frame(response, payload)
        raise TypeError.new("Payload must not be nil!") if payload.nil?

        # Yes, JSONed twice, there isn't a better way, we must pass
        # a string back, and the script, will be evaled() by the browser.
        "#{response.request.callback}(#{super.chomp.to_json});\r\n"
      end
    end

    class JSONPSend < DeliveryTransport
      register 'POST', 'jsonp_send'

      # Handler.
      def extract_message(request)
        if request.content_type == "application/x-www-form-urlencoded"
          raw_data = request.data.read || empty_payload
          begin
            data = Hash[URI.decode_www_form(raw_data)]

            data = data.fetch("d")
          rescue KeyError
            empty_payload
          end
        else
          data = request.data.read
        end

        if data.nil? or data.empty?
          empty_payload
        end
        data
      end

      def setup_response(request, response)
        response.status = 200
        response.set_content_type(:plain)
        response.set_session_id(request.session_id)
      end

      def successful_response(response)
        response.write("ok")
        response.finish
      end

      def error_content_type
        :html
      end

      def empty_payload
        raise SockJS::HttpError.new(500, "Payload expected.")
      end
    end
  end
end
