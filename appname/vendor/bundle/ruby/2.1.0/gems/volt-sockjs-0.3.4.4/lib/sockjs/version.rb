# encoding: utf-8

module SockJS
  # SockJS protocol version.
  PROTOCOL_VERSION = [0, 3, 4]

  PROTOCOL_VERSION_STRING = PROTOCOL_VERSION.join(".")

  # Patch version of the gem.
  PATCH_VERSION = [4]

  GEM_VERSION = (PROTOCOL_VERSION + PATCH_VERSION).join(".")
end
