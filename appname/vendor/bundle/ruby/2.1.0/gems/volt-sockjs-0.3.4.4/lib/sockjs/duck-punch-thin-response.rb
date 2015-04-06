require 'thin/response'
module Thin
  class Response
    TRANSFER_ENCODING = 'Transfer-Encoding'.freeze
    def persistent?
      return true if PERSISTENT_STATUSES.include?(@status)
      return false unless @persistent
      return true if @headers.has_key?(CONTENT_LENGTH)
      if @headers.has_key?(TRANSFER_ENCODING)
        header_string ||= @headers.to_s
        return true if /transfer-encoding: identity/i !~ header_string
      end
    end
  end
end
