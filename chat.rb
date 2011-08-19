# Original code is at https://gist.github.com/948374
module ChatClient
  def self.channel
    @channel ||= EM::Channel.new
  end

  def post_init
    @buf = ''
    @name = "anonymous_#{ChatClient.client_num+=1}"
    @sid = ChatClient.channel.subscribe { |msg|
      send_msg(msg)
    }
    # ...
    ChatClient.channel << "#{@name.bold} has joined.\n"
  end

  def unbind
    ChatClient.channel.unsubscribe(@sid)
    ChatClient.channel << "#{@name.bold} has left.\n"
  end

  def receive_data data
    @buf << data
    # ...
    while line = extract_line(@buf)
      ChatClient.channel << "#{@name.bold}: #{line}\n"
    end
  end

  # ...
end
