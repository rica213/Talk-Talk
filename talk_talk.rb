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
        # handle new client connection
        if socket.eql?(@server_socket)
          accept_new_connection

        # handle the client leaving
        elsif socket.eof?
          str = format("Client #{socket.peeraddr[2]}:#{socket.peeraddr[1]} left\n")
          broadcast(str, socket)
          socket.close
          @descriptors.delete(socket)
        
        # handle an incoming message
        else
          peer_address = socket.peeraddr
          received_data = socket.gets.chomp
          str = "[#{peer_address[2]}|#{peer_address[1]}]: #{received_data}\n"
          broadcast(str, socket)
        end
      end
    end
  end

  private

  def broadcast(str, omit_socket)
    @descriptors.each do |socket|
      socket.write(str) if socket != @server_socket && socket != omit_socket
    end

    print(str)
  end

  def accept_new_connection
    client_socket = @server_socket.accept
    @descriptors << client_socket

    client_socket.write("You're connected to Talk Talk\n")
    peer_address = client_socket.peeraddr
    str = "Client #{peer_address[2]}:#{peer_address[1]} joined\n"
    broadcast(str, client_socket)
  end
end

TalkTalk.new(8080).run
