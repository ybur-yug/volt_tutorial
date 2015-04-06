# encoding: utf-8

require "faye/websocket"

if defined? Thin
  Faye::WebSocket.load_adapter('thin')
end
if defined? Rainbows
  Faye::WebSocket.load_adapter('rainbows')
end
if defined? Goliath
  Faye::WebSocket.load_adapter('goliath')
end

class Thin::Request
  WEBSOCKET_RECEIVE_CALLBACK = 'websocket.receive_callback'.freeze
  GET = 'GET'.freeze
end
