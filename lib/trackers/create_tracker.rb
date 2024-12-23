require 'pry'
require 'http'

module Trackers
  class CreateTracker

    def initialize(item)
      @item = item
    end

    def call
      response = HTTP.post("https://fmt100-dev-66b0084c460c.herokuapp.com/graphql", params: { query: query(@item) })
      response.parse
    rescue StandardError => e
      Rails.logger.error("============================ #{e.message} ===================================")
      {}
    end

    private

    def query(item)
      <<~GQL
        mutation createTracker {
          createTracker(input: {
            imei: "#{item[:imei]}",
            latitude: #{item[:gps_data][:latitude]},
            longitude: #{item[:gps_data][:longitude]},
            speed: #{item[:gps_data][:speed]},
            dateTime: "#{item[:date_time]}"
          }){
            imei
            latitude
            longitude
            speed
            dateTime
            vehicleId
            totalOdometer
            tripOdometer
            address
            displayName
          }
        }
      GQL
    end
  end
end

# new = Trackers::CreateTracker.new({"imei":"357544374597827","number_of_rec":17,"date_time":"2022-07-05T13:05:26","priority":0,"gps_data":{"longitude":24.4257566,"latitude":58.8435066,"altitude":32,"angle":197,"satellites":19,"speed":99},"io_event_code":0,"number_of_io_elements":14,"io_data":{"239":1,"240":1,"21":4,"200":0,"69":1,"250":1,"181":5,"182":2,"66":13863,"67":4066,"68":0,"241":24801,"199":111,"16":774626}})
# new.call
