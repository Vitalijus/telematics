# require './lib/client_thread'
# require 'socket'
#
# RSpec.describe ClientThread do
#   let(:port) { 65432 }
#   let(:server) { ClientThread.new(port) }
#   let(:mock_client) { instance_double(TCPSocket) }
#
#   before do
#     allow(TCPServer).to receive(:open).and_return(instance_double(TCPServer, accept: mock_client))
#     allow(mock_client).to receive(:close)
#   end
#
#   describe '#initialize' do
#     it 'creates a TCP server on the specified port' do
#       expect(TCPServer).to receive(:open).with(port)
#       ClientThread.new(port)
#     end
#   end
#
#   describe '#log' do
#     it 'logs a message with a timestamp' do
#       message = "Test message"
#       time = Time.utc(2024, 1, 1, 12, 0, 0)
#       allow(Time).to receive(:now).and_return(time)
#       expect(server.log(message)).to eq("2024-01-01T12:00:00 #{message}")
#     end
#   end
#
#   describe '#handle_client' do
#     it 'authenticates the client and sends a response' do
#       imei = "123456789012345"
#       buffer = [0, imei].pack("Sa*")
#       allow(mock_client).to receive(:recv).and_return(buffer)
#       expect(mock_client).to receive(:send).with([0x01].pack("C"), 0)
#       server.handle_client(mock_client)
#     end
#
#     it 'sends a negative response if data is nil' do
#       buffer = [0, "123456789012345"].pack("Sa*")
#       allow(mock_client).to receive(:recv).and_return(buffer, nil)
#       expect(mock_client).to receive(:send).with([0x01].pack("C"), 0).ordered
#       expect(mock_client).to receive(:send).with([0x00].pack("C"), 0).ordered
#       server.handle_client(mock_client)
#     end
#   end
#
#   describe '#run' do
#     it 'starts the server loop and accepts clients' do
#       allow(Thread).to receive(:start).and_yield
#       expect(mock_client).to receive(:recv).and_return([0, "123456789012345"].pack("Sa*"))
#       expect(mock_client).to receive(:send).with([0x01].pack("C"), 0)
#       expect(mock_client).to receive(:close)
#       Thread.new { server.run }.kill # Start and immediately stop the loop
#     end
#   end
# end
