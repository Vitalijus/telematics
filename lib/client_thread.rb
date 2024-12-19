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

# Second, send message to the TCP Server using shell locally or on EC2 Ubuntu instance.
# Step one, auth module's IMEI.
# echo -n -e "\x00\x0F357544374597827" | nc localhost 65432

# Step two, decode telematics data.
# echo -n -e "00000000000004cb081100000181ce798780000e8d11c6230db408002500b30e005a000e06ef01f0011503c8004501fa0105b50006b60003423618430fe244000003f1000060e1c70000006510000be0b80000000181ce799b08000e8d11e7230d8995002500b3100055000e06ef01f0011503c8004501fa0105b50006b6000342361a430fe244000003f1000060e1c70000009210000be14a0000000181ce79b278000e8d1324230d5feb002200b2110054000e06ef01f0011503c8004501fa0105b50004b6000342362b430fe244000003f1000060e1c70000007710000be1c10000000181ce79c600000e8d13ec230d36f8002100b20f0054000e06ef01f0011504c8004501fa0105b50006b6000342360b430fe244000003f1000060e1c70000007410000be2350000000181ce79d988000e8d1482230d0df4001f00b3110054000e06ef01f0011504c8004501fa0105b50004b60003423608430fe244000003f1000060e1c70000007510000be2aa0000000181ce79ed10000e8d1549230ce3c4001f00b30f0057000e06ef01f0011504c8004501fa0105b50006b6000342361d430fe244000003f1000060e1c70000007810000be3220000000181ce7a0098000e8d1611230cb8aa002100b30f0058000e06ef01f0011504c8004501fa0105b50006b6000342361a430fe244000003f1000060e1c70000007a10000be39c0000000181ce7a1038000e8d172d230c8d0b002100b30f005a000e06ef01f0011504c8004501fa0105b50005b60003423612430fe144000003f1000060e1c70000007d10000be4190000000181ce7a23c0000e8d18de230c6203002100b30e0057000e06ef01f0011504c8004501fa0105b50006b6000342360d430fe244000003f1000060e1c70000007a10000be4930000000181ce7a3748000e8d1ad2230c3664001f00b30e005b000e06ef01f0011504c8004501fa0105b50006b6000342361a430fe544000003f1000060e1c70000007c10000be50f0000000181ce7a46e8000e8d1bab230c1274001d00b30e005b000e06ef01f0011504c8004501fa0105b50005b60003423620430fe644000003f1000060e1c70000006610000be5750000000181ce7a5a70000e8d1d09230be73a001a00b30f0058000e06ef01f0011504c8004501fa0105b50005b6000342361d430fe244000003f1000060e1c70000007c10000be5f10000000181ce7a6df8000e8d1dd1230bbc20001c00b30f0054000e06ef01f0011504c8004501fa0105b50004b60003423613430fe244000003f1000060e1c70000007a10000be66b0000000181ce7a8180000e8d209e230b932d001b00b20e0053000e06ef01f0011504c8004501fa0105b50005b60004423622430fe244000003f1000060e1c70000007510000be6e00000000181ce7a9508000e8d2018230b6b55001b00b3100051000e06ef01f0011504c8004501fa0105b50004b6000342361a430fe244000003f1000060e1c70000007110000be7510000000181ce7aa890000e8d1f61230b4251001c00b20f0055000e06ef01f0011505c8004501fa0105b50004b600034235f7430fde44000003f1000060e1c70000007510000be7c60000000181ce7abc18000e8d206b230b179c001b00b30f0057000e06ef01f0011505c8004501fa0105b50005b60003423619430fe244000003f1000060e1c70000007910000be83f00110000f717" | nc localhost 65432

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
                decoder = DataDecoder.new(data, @imei) # Decode data
                p self.log("FMT100 data decoding error: #{decoder}") if !decoder.present?
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
