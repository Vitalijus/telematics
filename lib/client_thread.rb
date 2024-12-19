# HOW IT WORKS?

# Teltonika module communicating with the server. First time module is authenticated by IMEI,
# second time data from module decoded and confirmation about number_of_rec is sent back to the module.
# Positive response is sent, if decoded num_of_rec matching with what
# module has send, then communication is over. Otherwise if decoded
# num_of_rec not matching with module's, then module will send data again
# Module is sending data packets every 2min.
# When num_of_rec matching Tracker data, like latitude, longitude, speed is being saved to the DB.

# After you have run required docker compose commands you might want to test TCP server
# on your local machine.
# First, confirm your TCP Server is running on local machine:
# lsof -iTCP -sTCP:LISTEN -n -P

# Confirm your TCP Server is running on AWS EC2 instance (Ubuntu):
# sudo lsof -i -P -n | grep LISTEN

# Second, send message to the TCP Server using shell locally or on EC2 Ubuntu instance:
# echo -n -e '\x00\x02000F333536333037303432343431303133\xAB\xCD' | nc localhost 65432

require 'socket'
require 'date'
require_relative 'data_decoder'
require_relative 'trackers_data'

class ClientThread
  def initialize(port)
    @server = TCPServer.open(port)
    @imei = "unknown"
  end

  def log(msg)
    "#{Time.now.utc.strftime('%FT%T')} #{msg}"
  end

  def run
    p self.log("Started TCP Server")

    loop do # loop is needed to run multiple Threads in parallel
      Thread.start(@server.accept) do |client|
        if client
          2.times do |index| # Start communication with module, first time device is authenticated,
            begin            # second data decoded and confirmation about number_of_rec is sent to module.
              buff = client.recv(8192)
              length, imei = buff.unpack("Sa*")
              data = buff.unpack("H*").first

              if index == 0 # First step in communication with module
                @imei = imei # save module imei
                p self.log("Device Authenticated | IMEI: #{@imei}")
                client.send([0x01].pack("C"), 0) # send response to module
              elsif index == 1 # Second step in communication with module
                p data
                decoder = DataDecoder.new(data, @imei) # Decode data
                p self.log("FMT100 data decoding error: #{decoder}")
                # Rollbar.log("error", "FMT100 data decoding error: #{decoder}") if !decoder.present?
                num_of_rec = decoder.number_of_rec # get number_of_rec

                if num_of_rec == 0
                  client.send([0x00].pack("C"), 0) # send negative response to module
                  client.close # close communication
                else
                  p decoder.decode
                  client.send([num_of_rec].pack("L>"), 0) # send positive response, if decoded num_of_rec matching with what
                  p self.log("Done! Closing Connection")  # module has send, then communication is over. Otherwise if decoded
                  client.close                            # num_of_rec not matching with module's, then module will send data again.

                  # TrackersData.new(decoder.decode) # Create Tracker
                end
              else
                client.send([0x00].pack("C"), 0) # send negative response to module
              end

            rescue SocketError
              p self.log("Socket has failed")
              # Rollbar.log("error", "Socket has failed")
            end
          end # end of loop twice

        else
          p self.log('Socket is null')
          # Rollbar.log("error", "Socket is null")
        end # if conditional
      end # end of Thread
    end # end of infinite loop
  end # run method
end # end of class

new_thread = ClientThread.new(65432)
p new_thread.run


# class ClientThread
#   NEGATIVE_RESPONSE = [0x00].pack("C")
#   AUTH_RESPONSE = [0x01].pack("C")
#
#   def initialize(port)
#     @server = TCPServer.open(port)
#     @imei = "unknown"
#   end
#
#   def log(message)
#     "#{Time.now.utc.strftime('%FT%T')} #{message}"
#   end
#
#   def handle_client(client)
#     2.times do |step|
#       begin
#         buffer = client.recv(8192)
#         length, imei = buffer.unpack("Sa*")
#         data = buffer.unpack("H*").first
#
#         case step
#         when 0
#           handle_authentication(client, imei)
#         when 1
#           handle_data_decoding(client, data)
#         else
#           client.send(NEGATIVE_RESPONSE, 0)
#         end
#       rescue SocketError
#         log_and_report("Socket has failed")
#       end
#     end
#   ensure
#     client.close if client
#   end
#
#   def handle_authentication(client, imei)
#     @imei = imei
#     log_and_report("Device Authenticated | IMEI: #{@imei}")
#     client.send(AUTH_RESPONSE, 0)
#   end
#
#   def handle_data_decoding(client, data)
#     decoder = DataDecoder.new(data, @imei)
#     if decoder.nil?
#       log_and_report("FMT100 data decoding error: #{decoder}")
#       client.send(NEGATIVE_RESPONSE, 0)
#       return
#     end
#
#     num_of_rec = decoder.number_of_rec
#     if num_of_rec == 0
#       client.send(NEGATIVE_RESPONSE, 0)
#     else
#       log_and_report("Decoded data: #{decoder.decode}")
#       client.send([num_of_rec].pack("L>"), 0)
#       log_and_report("Done! Closing Connection")
#     end
#   end
#
#   def log_and_report(message)
#     puts log(message)
#     # Rollbar.log("error", message) if Rollbar is enabled
#   end
#
#   def run
#     log_and_report("Started TCP Server")
#     loop do
#       Thread.start(@server.accept) do |client|
#         handle_client(client)
#       end
#     end
#   end
# end
#
# new_thread = ClientThread.new(65432)
# new_thread.run
