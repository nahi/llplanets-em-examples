require 'fiber'
require 'eventmachine'
require 'em-http-request'

def http_get(url)
  f = Fiber.current
  http = EventMachine::HttpRequest.new(url).get
  http.callback { f.resume(http) }
  http.errback  { f.resume(http) }
  Fiber.yield
end
 
EM.run do
  EM.add_periodic_timer(0.1) {
    print "."
  }

  Fiber.new {
    page = http_get('http://www.google.com/')
    puts "Fetched page: #{page.response_header.status}"
    EM.stop
  }.resume
end
