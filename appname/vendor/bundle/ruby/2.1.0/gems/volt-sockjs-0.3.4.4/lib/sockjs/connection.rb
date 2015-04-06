require 'sockjs'
require 'sockjs/callbacks'

module SockJS
  class Connection
    def initialize(session_class, options)
      self.status = :not_connected
      @session_class = session_class
      @options = options
    end
    attr_accessor :status, :options

    #XXX TODO: remove dead sessions as they're get_session'd, along with a
    #recurring clearout
    def sessions
      SockJS.debug "Refreshing sessions"

      if @sessions
        @sessions.delete_if do |_, session|
          unless session.alive?
            SockJS.debug "Removing closed session #{_}"
          end

          !session.alive?
        end
      else
        @sessions = {}
      end
    end

    def get_session(session_key)
      SockJS.debug "Looking up session at #{session_key.inspect}"
      sessions.fetch(session_key)
    end

    def create_session(session_key)
      SockJS.debug "Creating session at #{session_key.inspect}"
      raise "Session already exists for #{session_key.inspect}" if sessions.has_key?(session_key)
      session = @session_class.new(self)
      sessions[session_key] = session
      session.opened
      session
    end
  end
end
