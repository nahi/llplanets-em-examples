require './keep_alive_server.rb'
server = KeepAliveServer.new('127.0.0.1')

require 'em-http'
body = []
EM.run do
  conn = EventMachine::HttpRequest.new(server.url)
  req = conn.get(:keepalive => true)
  req.callback {
    body << req.response
    req = conn.get(:keepalive => true)
    req.callback {
      body << req.response
      req = conn.get(:keepalive => true)
      req.callback {
        body << req.response
        req = conn.get(:keepalive => true)
        req.callback {
          body << req.response
          req = conn.get(:keepalive => true)
          req.callback {
            body << req.response
            EM.stop
          }
          req.errback { EM.stop }
        }
        req.errback { EM.stop }
      }
      req.errback { EM.stop }
    }
    req.errback { EM.stop }
  }
  req.errback { EM.stop }
end

p body
