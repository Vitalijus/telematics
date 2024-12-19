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

# echo -n -e '\x00\x00000000000004cb081100000181ce740d28000e937b91231a48bc003000bc0f005a000e06ef01f0011503c8004501fa0105b50005b6000342361e430fe244000003f1000060e1c70000006710000bbba00000000181ce7420b0000e936dd5231a1d92003000bd0e0059000e06ef01f0011503c8004501fa0105b50005b60003423610430fe244000003f1000060e1c70000007c10000bbc1c0000000181ce743438000e935c302319f279003000bf0e005c000e06ef01f0011502c8004501fa0105b50007b60003423618430fe244000003f1000060e1c70000007e10000bbc9a0000000181ce7443d8000e934ea52319ce78002e00c00d005e000e06ef01f0011502c8004501fa0105b50007b6000442360f430fe244000003f1000060e1c70000006810000bbd020000000181ce745378000e933f162319ab40002e00c00d005b000e06ef01f0011502c8004501fa0105b50006b6000442361a430fe244000003f1000060e1c70000006710000bbd690000000181ce746700000e932af823198048002d00c20e005b000e06ef01f0011502c8004501fa0105b50006b60003423619430fe244000003f1000060e1c70000007e10000bbde70000000181ce7476a0000e93179223195de7002f00c30e005a000e06ef01f0011502c8004501fa0105b50005b6000342361e430fe244000003f1000060e1c70000006510000bbe4c0000000181ce748640000e93036323193bba002e00c50e005b000e06ef01f0011502c8004501fa0105b50007b6000442361b430fe244000003f1000060e1c70000006610000bbeb20000000181ce7499c8000e92e9de23191262002c00c60f0058000e06ef01f0011502c8004501fa0105b50006b60003423613430fe244000003f1000060e1c70000007c10000bbf2e0000000181ce74ad50000e92d0052318e886002e00c50e005d000e06ef01f0011502c8004501fa0105b50005b600034235aa430fde44000003f1000060e1c70000006310000bbf910000000181ce74bcf0000e92bc192318c410002e00c40e0067000e06ef01f0011502c8004501fa0105b50005b60003423606430fe144000003f1000060e1c70000008510000bc0160000000181ce74c8a8000e92afcb2318aee8002d00c40e0076000e06ef01f0011502c8004501fa0105b50005b6000342360d430fe244000003f1000060e1c70000003f10000bc0550000000181ce74d460000e929bbe23188b7d002800c60e007c000e06ef01f0011502c8004501fa0105b50005b60003423618430fe044000003f1000060e1c70000006910000bc0be0000000181ce74e018000e928505231869c4002900c60e0077000e06ef01f0011502c8004501fa0105b50007b6000342362e430fe244000003f1000060e1c70000006610000bc1240000000181ce74efb8000e92693823183eed002b00c50f0072000e06ef01f0011502c8004501fa0105b50006b6000342361e430fe244000003f1000060e1c70000008010000bc1a40000000181ce74ff58000e9250ce2318160a002e00c50d006c000e06ef01f0011502c8004501fa0105b50005b6000442361a430fe244000003f1000060e1c70000007a10000bc21e0000000181ce750b10000e9236a22317edef002f00c50d006c000e06ef01f0011502c8004501fa0105b50007b60004423619430fe244000003f1000060e1c70000007810000bc2960011000076ce\xAB\xCD' | nc localhost 65432




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
                p buff
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
