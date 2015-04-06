# encoding: utf-8

require "json"

module SockJS
  module Protocol
    CHARS_TO_BE_ESCAPED ||= /[\x00-\x1f\u200c-\u200f\u2028-\u202f\u2060-\u206f\ufff0-\uffff]/

    class Frame
      # JSON Unicode Encoding
      # =====================
      #
      # SockJS takes the responsibility of encoding Unicode strings for
      # the user. The idea is that SockJS should properly deliver any
      # valid string from the browser to the server and back. This is
      # actually quite hard, as browsers do some magical character
      # translations. Additionally there are some valid characters from
      # JavaScript point of view that are not valid Unicode, called
      # surrogates (JavaScript uses UCS-2, which is not really Unicode).
      #
      # Dealing with unicode surrogates (0xD800-0xDFFF) is quite special.
      # If possible we should make sure that server does escape decode
      # them. This makes sense for SockJS servers that support UCS-2
      # (SockJS-node), but can't really work for servers supporting unicode
      # properly (Python).
      #
      # The server can't send Unicode surrogates over Websockets, also various
      # \u2xxxx chars get mangled. Additionally, if the server is capable of
      # handling UCS-2 (ie: 16 bit character size), it should be able to deal
      # with Unicode surrogates 0xD800-0xDFFF:
      # http://en.wikipedia.org/wiki/Mapping_of_Unicode_characters#Surrogates
      def escape(string)
        string.gsub(CHARS_TO_BE_ESCAPED) do |match|
          '\u%04x' % (match.ord)
        end
      end

      def validate(desired_class, object)
        unless object.is_a?(desired_class)
          raise TypeError.new("#{desired_class} object expected, but object is an instance of #{object.class} (object: #{object.inspect}).")
        end
      end
    end

    class HeartbeatFrame < Frame
      def initialize
      end

      def self.instance
        @instance ||= self.new
      end

      def to_s
        "h"
      end
    end

    class OpeningFrame < Frame
      def initialize
      end

      def self.instance
        @instance ||= self.new
      end

      def to_s
        "o"
      end
    end

    class ArrayFrame < Frame
      def initialize(array)
        @array = array
        validate Array, array
      end
      attr_reader :array

      def to_s
        "a#{escape(array.to_json)}"
      end
    end


    class ClosingFrame < Frame
      def initialize(status=1000, message="Normal closing")
        validate Integer, status
        validate String, message

        @status, @message = status, message
      end

      def to_s
        "c[#{@status},#{escape(@message.inspect)}]"
      end
    end
  end
end
