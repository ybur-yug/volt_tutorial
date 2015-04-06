# encoding: utf-8

require 'sockjs/delayed-response-body'

module SockJS
  #Adapter for Thin Rack responses.  It's a TODO feature to support other
  #webservers and compatibility layers
  class Response
    extend Forwardable
    attr_reader :request, :status, :headers, :body
    attr_writer :status

    def initialize(request, status = nil, headers = nil, &block)
      # request.env["async.close"]
      # ["rack.input"].closed? # it's a stream
      @request, @status, @headers = request, status, headers || {}

      if request.http_1_0?
        SockJS.debug "Request is in HTTP/1.0, responding with HTTP/1.0"
        @body = DelayedResponseBody.new
      else
        @body = DelayedResponseChunkedBody.new
      end

      @body.callback do
        @request.succeed
      end

      @body.errback do
        @request.fail
      end

      block.call(self) if block

      set_connection_keep_alive_if_requested
    end

    def session=(session)
      @body.session = session
    end

    def turn_chunking_on(headers)
      headers["Transfer-Encoding"] = "chunked"
    end


    def write_head(status = nil, headers = nil)
      @status  = status  || @status  || raise("Please set the status!")
      @headers = headers || @headers

      if @headers["Content-Length"]
        raise "You can't use Content-Length with chunking!"
      end

      unless @request.http_1_0? || @status == 204
        turn_chunking_on(@headers)
      end

      SockJS.debug "Writing headers: #{@status.inspect}/#{@headers.inspect}"
      @request.async_callback.call([@status, @headers, @body])

      @head_written = true
    end

    def head_written?
      !! @head_written
    end

    def write(data)
      self.write_head unless self.head_written?

      @last_written_at = Time.now.to_i

      @body.write(data)
    end

    def finish(data = nil, &block)
      if data
        self.write(data)
      else
        self.write_head unless self.head_written?
      end

      @body.finish
    end

    def async?
      true
    end

    # Time.now.to_i shows time in seconds.
    def due_for_alive_check
      Time.now.to_i != @last_written_at
    end

    def set_status(status)
      @status = status
    end

    def set_header(key, value)
      @headers[key] = value
    end

    def set_session_id(session_id)
      self.headers["Set-Cookie"] = "JSESSIONID=#{session_id}; path=/"
    end

    # === Helpers === #
    def set_access_control(origin)
      self.set_header("Access-Control-Allow-Origin", origin)
      self.set_header("Access-Control-Allow-Credentials", "true")
      self.set_header("Access-Control-Allow-Headers", "Content-Type Origin Accept X-Requested-With X-CSRF-Token If-Modified-Since If-None-Match Auth-User-Token Authorization Connection Cookie User-Agent")
    end

    def set_cache_control
      year = 31536000
      time = Time.now + year

      self.set_header("Cache-Control", "public, max-age=#{year}")
      self.set_header("Expires", time.gmtime.to_s)
      self.set_header("Access-Control-Max-Age", "1000001")
    end

    def set_allow_options_post
      self.set_header("Allow", "OPTIONS, POST")
      self.set_header("Access-Control-Allow-Methods", "OPTIONS, POST")
    end

    def set_allow_options_get
      self.set_header("Allow", "OPTIONS, GET")
      self.set_header("Access-Control-Allow-Methods", "OPTIONS, GET")
    end

    def set_no_cache
      self.set_header("Cache-Control", "no-store, no-cache, must-revalidate, max-age=0")
    end

    CONTENT_TYPES ||= {
      plain: "text/plain; charset=UTF-8",
      html: "text/html; charset=UTF-8",
      javascript: "application/javascript; charset=UTF-8",
      json: "application/json; charset=UTF-8",
      event_stream: "text/event-stream; charset=UTF-8"
    }

    def set_content_length(body)
      if body && body.respond_to?(:bytesize)
        self.headers["Content-Length"] = body.bytesize.to_s
      end
    end

    def set_content_type(symbol)
      if string = CONTENT_TYPES[symbol]
        self.set_header("Content-Type", string)
      else
        raise "No such content type: #{symbol}"
      end
    end

    def set_connection_keep_alive_if_requested
      if @request.env["HTTP_CONNECTION"] && @request.env["HTTP_CONNECTION"].downcase == "keep-alive"
        if @request.http_1_0?
          self.set_header("Connection", "Close")
        else
          self.set_header("Connection", "Keep-Alive")
        end
      end
    end
  end
end
