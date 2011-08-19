require 'eventmachine'

module MyKeyboardHandler
  include EM::Protocols::LineText2
  def receive_line data
    puts "I received the following line: #{data}"
    EM.stop if data == "quit"
  end
end

EM.run do
  EM.open_keyboard(MyKeyboardHandler)
end
