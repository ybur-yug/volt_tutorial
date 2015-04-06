# encoding: utf-8

require 'eventmachine'

module SockJS
  class DelayedResponseBody
    include EventMachine::Deferrable

    attr_accessor :session

    def initialize
      @status = :created
    end

    def call(body)
      body.each do |chunk|
        self.write(chunk)
      end
    end

    def write(chunk)
      unless @status == :open
        raise "Body isn't open (status: #{@status}, trying to write #{chunk.inspect})"
      end

      unless chunk.respond_to?(:bytesize)
        raise "Chunk is supposed to respond to #bytesize, but it doesn't.\nChunk: #{chunk.inspect} (#{chunk.class})"
      end

      SockJS.debug "body#write #{chunk.inspect}"

      self.write_chunk(chunk)
    end

    def each(&block)
      SockJS.debug "Opening the response."
      @status = :open
      @body_callback = block
    end

    def succeed(from_server = true)
      SockJS.debug "Closing the response."
      if $DEBUG and false
        SockJS.debug caller[0..-8].map { |item| item.sub(Dir.pwd + "/lib/", "") }.inspect
      end

      @status = :closed
      super
    end

    def finish(data = nil)
      if @status == :closed
        raise "Body is already closed!"
      end

      self.write(data) if data

      self.succeed(true)
    end

    def closed?
      @status == :closed
    end

    protected
    def write_chunk(chunk)
      self.__write__(chunk)
    end

    def __write__(data)
      SockJS.debug "Data to client %% #{data.inspect}"
      @body_callback.call(data)
    end
  end


  # https://github.com/rack/rack/blob/master/lib/rack/chunked.rb
  class DelayedResponseChunkedBody < DelayedResponseBody
    TERM ||= "\r\n"
    TAIL ||= "0#{TERM}#{TERM}"

    def finish(data = nil)
      if @status == :closed
        raise "Body is already closed!"
      end

      self.write(data) if data
      self.__write__(TAIL)

      self.succeed(true)
    end

    protected
    def write_chunk(chunk)
      data = [chunk.bytesize.to_s(16), TERM, chunk, TERM].join
      self.__write__(data)
    end
  end
end
