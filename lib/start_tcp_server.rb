require_relative "client_thread"

class StartTcpServer
  def start
    new_thread = ClientThread.new(65432)
    new_thread.run
  end
end

server = StartTcpServer.new
server.start
