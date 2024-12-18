# HOW IT WORKS?
# Teltonika module communicating with the server. First time module is authenticated by IMEI,
# second time data from module decoded and confirmation about number_of_rec is sent back to the module.
# Positive response is sent, if decoded num_of_rec matching with what
# module has send, then communication is over. Otherwise if decoded
# num_of_rec not matching with module's, then module will send data again
# Module is sending data packets every 2min.
# When num_of_rec matching Tracker data, like latitude, longitude, speed is being saved to the DB.

require 'socket'
require 'date'
require 'data_decoder'
require 'trackers_data'

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
