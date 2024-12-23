require 'pry'
require_relative 'trackers/create_tracker'

class DataBuilder
  def initialize(data)
    @data = data
  end

  def data_builder
    @data.each do |item|
      if tracker_valid?(item)
        io_data = io_data(item)

        new_tracker = Trackers::CreateTracker.new(item, io_data)
        new_tracker.call
      end
    end
  end

  private

  # Check if gps data is above certain level
  def tracker_valid?(item)
    item[:gps_data][:latitude] != 0.0 &&
      item[:gps_data][:longitude] != 0.0 &&
      item[:gps_data][:speed] > 3
  end

  # IO data collection.
  def io_data(item)
    io_hash = {}

    item[:io_data].each do |k,v|
      io_hash[:total_odometer] = v if k == 16 # IO Total odometer
      io_hash[:trip_odometer] = v if k == 199 # IO Trip odometer
    end

    io_hash
  end
end

# new_data_builder = DataBuilder.new([{:imei=>"357544374597827", :number_of_rec=>17, :date_time=>"2022-07-05T13:05:26", :priority=>0, :gps_data=>{:longitude=>24.4257566, :latitude=>58.8435066, :altitude=>32, :angle=>197, :satellites=>19, :speed=>99}, :io_event_code=>0, :number_of_io_elements=>14, :io_data=>{239=>1, 240=>1, 21=>4, 200=>0, 69=>1, 250=>1, 181=>5, 182=>2, 66=>13863, 67=>4066, 68=>0, 241=>24801, 199=>111, 16=>774626}}, {:imei=>"357544374597827", :number_of_rec=>17, :date_time=>"2022-07-05T13:05:30", :priority=>0, :gps_data=>{:longitude=>24.4252016, :latitude=>58.8425816, :altitude=>33, :angle=>197, :satellites=>19, :speed=>97}, :io_event_code=>0, :number_of_io_elements=>14, :io_data=>{239=>1, 240=>1, 21=>4, 200=>0, 69=>1, 250=>1, 181=>4, 182=>2, 66=>13859, 67=>4066, 68=>0, 241=>24801, 199=>107, 16=>774733}}, {:imei=>"357544374597827", :number_of_rec=>17, :date_time=>"2022-07-05T13:05:34", :priority=>0, :gps_data=>{:longitude=>24.4246566, :latitude=>58.8416783, :altitude=>33, :angle=>197, :satellites=>19, :speed=>95}, :io_event_code=>0, :number_of_io_elements=>14, :io_data=>{239=>1, 240=>1, 21=>4, 200=>0, 69=>1, 250=>1, 181=>5, 182=>2, 66=>13848, 67=>4066, 68=>0, 241=>24801, 199=>105, 16=>774838}}, {:imei=>"357544374597827", :number_of_rec=>17, :date_time=>"2022-07-05T13:05:38", :priority=>0, :gps_data=>{:longitude=>24.4241016, :latitude=>58.8407916, :altitude=>30, :angle=>197, :satellites=>18, :speed=>92}, :io_event_code=>0, :number_of_io_elements=>14, :io_data=>{239=>1, 240=>1, 21=>4, 200=>0, 69=>1, 250=>1, 181=>5, 182=>2, 66=>13843, 67=>4066, 68=>0, 241=>24801, 199=>104, 16=>774942}}, {:imei=>"357544374597827", :number_of_rec=>17, :date_time=>"2022-07-05T13:05:42", :priority=>0, :gps_data=>{:longitude=>24.4235516, :latitude=>58.8399133, :altitude=>29, :angle=>197, :satellites=>16, :speed=>90}, :io_event_code=>0, :number_of_io_elements=>14, :io_data=>{239=>1, 240=>1, 21=>3, 200=>0, 69=>1, 250=>1, 181=>4, 182=>3, 66=>13846, 67=>4066, 68=>0, 241=>24801, 199=>103, 16=>775045}}, {:imei=>"357544374597827", :number_of_rec=>17, :date_time=>"2022-07-05T13:06:34", :priority=>0, :gps_data=>{:longitude=>24.4168166, :latitude=>58.8289183, :altitude=>20, :angle=>198, :satellites=>12, :speed=>95}, :io_event_code=>0, :number_of_io_elements=>14, :io_data=>{239=>1, 240=>1, 21=>3, 200=>0, 69=>1, 250=>1, 181=>6, 182=>3, 66=>13853, 67=>4066, 68=>0, 241=>24801, 199=>102, 16=>776327}}, {:imei=>"357544374597827", :number_of_rec=>17, :date_time=>"2022-07-05T13:06:38", :priority=>0, :gps_data=>{:longitude=>24.4162416, :latitude=>58.82803, :altitude=>18, :angle=>196, :satellites=>12, :speed=>94}, :io_event_code=>0, :number_of_io_elements=>14, :io_data=>{239=>1, 240=>1, 21=>3, 200=>0, 69=>1, 250=>1, 181=>9, 182=>4, 66=>13846, 67=>4066, 68=>0, 241=>24801, 199=>104, 16=>776431}}])
# new_data_builder.data_builder
