require 'socket'

class TalkTalk
  def initialize(port)
    @descriptors = []
    @server_socket = TCPServer.new('', port)
    @server_socket.setsockopt(Socket::SOL_SOCKET, Socket::SO_REUSEADDR, 1)
    printf("Chatserver started on port %d\n", port)
    @descriptors << @server_socket
  end

  def run
    loop do
      result = select(@descriptors, nil, nil, nil)
      next if result.nil?
      (result[0]).each do |socket|
        if socket.eql?(@server_socket)
          accept_new_connection
        elsif socket.eof?
          str = format('Client left %<socket.peeraddr[2]>s: %<socket.peeraddr[1]>s\n')
          broadcast_string(str, socket)
          socket.close
          @descriptors.delete(socket)
        else
          str = format('[%<socket.peeraddr[2]>s|%<socket.peeraddr[1]>s]: %<socket.gets>s')
          broadcast_string(str, socket)
        end
      end
    end
  end

  private

  def broadcast_string(str, omit_socket)
    
  end

  def accept_new_connection

  end
end
