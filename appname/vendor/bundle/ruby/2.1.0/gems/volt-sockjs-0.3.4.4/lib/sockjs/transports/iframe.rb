# encoding: utf-8

require "digest/md5"
require "sockjs/transport"

module SockJS
  module Transports
    class IFrame < Endpoint
      register 'GET', %r{/iframe[^/]*[.]html}

      BODY = <<-EOB.freeze
<!DOCTYPE html>
<html>
<head>
  <meta http-equiv="X-UA-Compatible" content="IE=edge" />
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
  <script>
    document.domain = document.domain;
    _sockjs_onload = function(){SockJS.bootstrap_iframe();};
  </script>
  <script src="{{ sockjs_url }}"></script>
</head>
<body>
  <h2>Don't panic!</h2>
  <p>This is a SockJS hidden iframe. It's used for cross domain magic.</p>
</body>
</html>
      EOB

      def setup_response(request, response)
        SockJS.debug("body: #{@body.inspect}")
        response.status = 200
        response.set_header("ETag", self.etag)
        response.set_cache_control
        response
      end

      def body
        @body ||= BODY.gsub("{{ sockjs_url }}", options[:sockjs_url])
      end

      def digest
        @digest ||= Digest::MD5.new
      end

      def etag
        '"' + digest.hexdigest(body) + '"'
      end

      # Handler.
      def handle_request(request)
        if request.fresh?(etag)
          response = build_response(request)
          response.status = 304
          response.finish
          return response
        else
          SockJS.debug "Deferring to Transport"
          response = build_response(request)
          response.set_content_type(:html)
          response.write(body)
          response.finish
          return response
        end
      end
    end
  end
end
