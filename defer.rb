require 'eventmachine'

def invoke_blocking_process
  # It's blocking in CRuby!
  # OpenSSL::PKey::RSA.new(4096)
  # a little better; it allows to switch Threads between iterations
  # OpenSSL::PKey::RSA.new(4096) {}
  STDIN.gets
end

EM.run do
  EM.add_periodic_timer(0.1) {
    print "."
  }

  EM.defer(
    -> {
      invoke_blocking_process
    },
    ->(out) {
      puts 'done'
      EM.stop
    }
  )
end
