require 'socket'

class TalkTalk
  def initialize(port)
    @descriptors = []
    @server_socket = TCPServer.new('', port)
    @server_socket.setsockopt(Socket::SOL_SOCKET, Socket::SO_REUSEADDR, 1)
    printf("Chatserver started on port %d\n", port)
    @descriptors << @server_socket
  end
end
