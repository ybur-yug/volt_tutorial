require 'rack/mount/utils'

module Rack::Mount::Utils
  def normalize_path(path)
    path = "/#{path}" unless path[0] = ?/
    path = '/' if path == ''
    path

    return path
  end
  module_function :normalize_path
end
