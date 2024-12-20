# decoder = DataDecoder.new(data, @imei)
# decoder.decode

# Payload data:
# @imei="\x00\x0F357544374597827"
# data = "00000000000004cb081100000181ce8143f8000e8ece9022fdaa6f001500ae110000f00e06ef01f0001504c8004501fa0105b50004b600034231a6430fe244000003f1000060e1c70000000010000c0ecb0000000181ce814fb0000e8ece9022fdaa6f001500ae110000ef0e06ef00f0001504c8004501fa0105b50004b60003423191430fe044000003f1000060e1c70000000010000c0ecb0000000181ce822e58000e8ece9022fdaa6f001500ae0f0000fa0e06ef00f0001504c8004501fa0005b50005b600034231aa430fe244000003f1000060e1c70000000010000c0ecb0000000181ce8942d8000e8ee22922fd8fad000c008b0d0015f00e06ef00f0011503c8004501fa0005b50007b600044235f9430fe244000003f1000060e1c70000005510000c0f200000000181ce8946c0000e8ee5f022fd8d55000c008f0e0017fa0e06ef00f0011503c8004501fa0105b50007b600044235f5430fde44000003f1000060e1c70000000910000c0f290000000181ce894e90000e8eea6e22fd891a000c00940e0018ef0e06ef01f0011504c8004501fa0105b50005b600034235f3430fe044000003f1000060e1c70000000e10000c0f370000000181ce895660000e8ef03922fd8564000d00840e0019000e06ef01f0011504c8004501fa0105b50007b600044235fc430fe044000003f1000060e1c70000000d10000c0f440000000181ce895e30000e8ef8f222fd8265000d00740e001c000e06ef01f0011504c8004501fa0105b50005b600034235f5430fe244000003f1000060e1c70000001010000c0f540000000181ce896dd0000e8f093922fd7d94000d007f0e000b000e06ef01f0011504c8004501fa0105b50005b600034235ea430fe244000003f1000060e1c70000001c10000c0f700000000181ce8975a0000e8f0a1222fd7cdc000e007f0e0000000e06ef01f0011504c8004501fa0105b50005b600034235f6430fe244000003f1000060e1c70000000010000c0f700000000181ce89ac50000e8f116d22fd797a000e00930f000e000e06ef01f0011504c8004501fa0105b50007b60003423614430fe244000003f1000060e1c70000001110000c0f810000000181ce89b038000e8f14e022fd74b9000e00a20f0027000e06ef01f0011504c8004501fa0105b50007b60003423610430fe244000003f1000060e1c70000000e10000c0f8f0000000181ce89b808000e8f1a9b22fd6af5000f00a4100035000e06ef01f0011504c8004501fa0105b50007b6000342361c430fe144000003f1000060e1c70000001d10000c0fac0000000181ce89bfd8000e8f21a322fd5ed9000f00a4100043000e06ef01f0011505c8004501fa0105b50005b6000342361a430fe044000003f1000060e1c70000002410000c0fd00000000181ce89c7a8000e8f2bdc22fd4fe0001000a00e0050000e06ef01f0011505c8004501fa0105b50007b60003423611430fe244000003f1000060e1c70000002e10000c0ffe0000000181ce89db30000e8f460722fd27610010009f0d0059000e06ef01f0011505c8004501fa0105b50005b60004423616430fe244000003f1000060e1c70000007910000c10770000000181ce89eeb8000e8f640b22fcff78001200a00e0055000e06ef01f0011505c8004501fa0105b50007b60004423613430fe144000003f1000060e1c70000007a10000c10f1001100007f8a"

# Results example:
# [{:imei=>"357544374597827", :number_of_rec=>17, :date_time=>"2022-07-05T13:05:26", :priority=>0, :gps_data=>{:longitude=>24.4257566, :latitude=>58.8435066, :altitude=>32, :angle=>197, :satellites=>19, :speed=>99}, :io_event_code=>0, :number_of_io_elements=>14, :io_data=>{239=>1, 240=>1, 21=>4, 200=>0, 69=>1, 250=>1, 181=>5, 182=>2, 66=>13863, 67=>4066, 68=>0, 241=>24801, 199=>111, 16=>774626}}, {:imei=>"357544374597827", :number_of_rec=>17, :date_time=>"2022-07-05T13:05:30", :priority=>0, :gps_data=>{:longitude=>24.4252016, :latitude=>58.8425816, :altitude=>33, :angle=>197, :satellites=>19, :speed=>97}, :io_event_code=>0, :number_of_io_elements=>14, :io_data=>{239=>1, 240=>1, 21=>4, 200=>0, 69=>1, 250=>1, 181=>4, 182=>2, 66=>13859, 67=>4066, 68=>0, 241=>24801, 199=>107, 16=>774733}}, {:imei=>"357544374597827", :number_of_rec=>17, :date_time=>"2022-07-05T13:05:34", :priority=>0, :gps_data=>{:longitude=>24.4246566, :latitude=>58.8416783, :altitude=>33, :angle=>197, :satellites=>19, :speed=>95}, :io_event_code=>0, :number_of_io_elements=>14, :io_data=>{239=>1, 240=>1, 21=>4, 200=>0, 69=>1, 250=>1, 181=>5, 182=>2, 66=>13848, 67=>4066, 68=>0, 241=>24801, 199=>105, 16=>774838}}, {:imei=>"357544374597827", :number_of_rec=>17, :date_time=>"2022-07-05T13:05:38", :priority=>0, :gps_data=>{:longitude=>24.4241016, :latitude=>58.8407916, :altitude=>30, :angle=>197, :satellites=>18, :speed=>92}, :io_event_code=>0, :number_of_io_elements=>14, :io_data=>{239=>1, 240=>1, 21=>4, 200=>0, 69=>1, 250=>1, 181=>5, 182=>2, 66=>13843, 67=>4066, 68=>0, 241=>24801, 199=>104, 16=>774942}}, {:imei=>"357544374597827", :number_of_rec=>17, :date_time=>"2022-07-05T13:05:42", :priority=>0, :gps_data=>{:longitude=>24.4235516, :latitude=>58.8399133, :altitude=>29, :angle=>197, :satellites=>16, :speed=>90}, :io_event_code=>0, :number_of_io_elements=>14, :io_data=>{239=>1, 240=>1, 21=>3, 200=>0, 69=>1, 250=>1, 181=>4, 182=>3, 66=>13846, 67=>4066, 68=>0, 241=>24801, 199=>103, 16=>775045}}, {:imei=>"357544374597827", :number_of_rec=>17, :date_time=>"2022-07-05T13:05:47", :priority=>0, :gps_data=>{:longitude=>24.422915, :latitude=>58.8388483, :altitude=>30, :angle=>197, :satellites=>16, :speed=>89}, :io_event_code=>0, :number_of_io_elements=>14, :io_data=>{239=>1, 240=>1, 21=>3, 200=>0, 69=>1, 250=>1, 181=>5, 182=>3, 66=>13843, 67=>4066, 68=>0, 241=>24801, 199=>123, 16=>775168}}, {:imei=>"357544374597827", :number_of_rec=>17, :date_time=>"2022-07-05T13:05:52", :priority=>0, :gps_data=>{:longitude=>24.4222633, :latitude=>58.8377783, :altitude=>33, :angle=>197, :satellites=>17, :speed=>88}, :io_event_code=>0, :number_of_io_elements=>14, :io_data=>{239=>1, 240=>1, 21=>3, 200=>0, 69=>1, 250=>1, 181=>4, 182=>3, 66=>13850, 67=>4066, 68=>0, 241=>24801, 199=>125, 16=>775293}}, {:imei=>"357544374597827", :number_of_rec=>17, :date_time=>"2022-07-05T13:05:57", :priority=>0, :gps_data=>{:longitude=>24.4216666, :latitude=>58.8367316, :altitude=>29, :angle=>197, :satellites=>19, :speed=>86}, :io_event_code=>0, :number_of_io_elements=>14, :io_data=>{239=>1, 240=>1, 21=>3, 200=>0, 69=>1, 250=>1, 181=>5, 182=>2, 66=>13840, 67=>4066, 68=>0, 241=>24801, 199=>121, 16=>775414}}, {:imei=>"357544374597827", :number_of_rec=>17, :date_time=>"2022-07-05T13:06:02", :priority=>0, :gps_data=>{:longitude=>24.42104, :latitude=>58.8357233, :altitude=>32, :angle=>197, :satellites=>19, :speed=>85}, :io_event_code=>0, :number_of_io_elements=>14, :io_data=>{239=>1, 240=>1, 21=>3, 200=>0, 69=>1, 250=>1, 181=>5, 182=>2, 66=>13854, 67=>4066, 68=>0, 241=>24801, 199=>118, 16=>775532}}, {:imei=>"357544374597827", :number_of_rec=>17, :date_time=>"2022-07-05T13:06:07", :priority=>0, :gps_data=>{:longitude=>24.4204033, :latitude=>58.834715, :altitude=>34, :angle=>197, :satellites=>17, :speed=>85}, :io_event_code=>0, :number_of_io_elements=>14, :io_data=>{239=>1, 240=>1, 21=>3, 200=>0, 69=>1, 250=>1, 181=>5, 182=>3, 66=>13788, 67=>4061, 68=>0, 241=>24801, 199=>118, 16=>775650}}, {:imei=>"357544374597827", :number_of_rec=>17, :date_time=>"2022-07-05T13:06:12", :priority=>0, :gps_data=>{:longitude=>24.41977, :latitude=>58.8336816, :altitude=>31, :angle=>197, :satellites=>18, :speed=>87}, :io_event_code=>0, :number_of_io_elements=>14, :io_data=>{239=>1, 240=>1, 21=>3, 200=>0, 69=>1, 250=>1, 181=>5, 182=>2, 66=>13840, 67=>4066, 68=>0, 241=>24801, 199=>121, 16=>775771}}, {:imei=>"357544374597827", :number_of_rec=>17, :date_time=>"2022-07-05T13:06:17", :priority=>0, :gps_data=>{:longitude=>24.41911, :latitude=>58.832625, :altitude=>28, :angle=>197, :satellites=>17, :speed=>87}, :io_event_code=>0, :number_of_io_elements=>14, :io_data=>{239=>1, 240=>1, 21=>3, 200=>0, 69=>1, 250=>1, 181=>4, 182=>2, 66=>13843, 67=>4062, 68=>0, 241=>24801, 199=>123, 16=>775894}}, {:imei=>"357544374597827", :number_of_rec=>17, :date_time=>"2022-07-05T13:06:22", :priority=>0, :gps_data=>{:longitude=>24.4184616, :latitude=>58.83157, :altitude=>24, :angle=>198, :satellites=>15, :speed=>91}, :io_event_code=>0, :number_of_io_elements=>14, :io_data=>{239=>1, 240=>1, 21=>3, 200=>0, 69=>1, 250=>1, 181=>5, 182=>3, 66=>13848, 67=>4066, 68=>0, 241=>24801, 199=>123, 16=>776017}}, {:imei=>"357544374597827", :number_of_rec=>17, :date_time=>"2022-07-05T13:06:26", :priority=>0, :gps_data=>{:longitude=>24.4179183, :latitude=>58.8306816, :altitude=>22, :angle=>198, :satellites=>14, :speed=>93}, :io_event_code=>0, :number_of_io_elements=>14, :io_data=>{239=>1, 240=>1, 21=>3, 200=>0, 69=>1, 250=>1, 181=>6, 182=>3, 66=>13844, 67=>4067, 68=>0, 241=>24801, 199=>104, 16=>776121}}, {:imei=>"357544374597827", :number_of_rec=>17, :date_time=>"2022-07-05T13:06:30", :priority=>0, :gps_data=>{:longitude=>24.4173383, :latitude=>58.82979, :altitude=>25, :angle=>197, :satellites=>13, :speed=>94}, :io_event_code=>0, :number_of_io_elements=>14, :io_data=>{239=>1, 240=>1, 21=>3, 200=>0, 69=>1, 250=>1, 181=>5, 182=>3, 66=>13692, 67=>4065, 68=>0, 241=>24801, 199=>104, 16=>776225}}, {:imei=>"357544374597827", :number_of_rec=>17, :date_time=>"2022-07-05T13:06:34", :priority=>0, :gps_data=>{:longitude=>24.4168166, :latitude=>58.8289183, :altitude=>20, :angle=>198, :satellites=>12, :speed=>95}, :io_event_code=>0, :number_of_io_elements=>14, :io_data=>{239=>1, 240=>1, 21=>3, 200=>0, 69=>1, 250=>1, 181=>6, 182=>3, 66=>13853, 67=>4066, 68=>0, 241=>24801, 199=>102, 16=>776327}}, {:imei=>"357544374597827", :number_of_rec=>17, :date_time=>"2022-07-05T13:06:38", :priority=>0, :gps_data=>{:longitude=>24.4162416, :latitude=>58.82803, :altitude=>18, :angle=>196, :satellites=>12, :speed=>94}, :io_event_code=>0, :number_of_io_elements=>14, :io_data=>{239=>1, 240=>1, 21=>3, 200=>0, 69=>1, 250=>1, 181=>9, 182=>4, 66=>13846, 67=>4066, 68=>0, 241=>24801, 199=>104, 16=>776431}}]

class DataDecoder
  def initialize(payload, imei)
    @payload = payload
    @imei = imei
    @precision = 10000000.0
  end

  def number_of_rec
    @payload[18..19].to_i(16)
  end

  def number_of_total_rec
    @payload[-10..-9].to_i(16)
  end

  def avl_data
    @payload[20..-9]
  end

  def timestamp(avl_data, position)
    timestamp_hex = avl_data[position..position+15]
    timestamp_decode = timestamp_hex.to_i(16)
    DateTime.strptime(timestamp_decode.to_s, '%Q').strftime('%FT%T')
  end

  def priority(avl_data, position)
    priority_hex = avl_data[position..position+1]
    priority_hex.to_i(16)
  end

  def longitude(avl_data, position)
    longitude_hex = avl_data[position..position+7]
    longitude_decode = longitude_hex.to_i(16)
    longitude_decode / @precision
  end

  def latitude(avl_data, position)
    latitude_hex = avl_data[position..position+7]
    latitude_decode = latitude_hex.to_i(16)
    latitude_decode / @precision
  end

  def altitude(avl_data, position)
    altitude_hex = avl_data[position..position+3]
    altitude_hex.to_i(16)
  end

  def angle(avl_data, position)
    angle_hex = avl_data[position..position+3]
    angle_hex.to_i(16)
  end

  def satellites(avl_data, position)
    satellites_hex = avl_data[position..position+1]
    satellites_hex.to_i(16)
  end

  def speed(avl_data, position)
    speed_hex = avl_data[position..position+3]
    speed_hex.to_i(16)
  end

  def io_event_code(avl_data, position)
    avl_data[position..position + 1].to_i(16)
  end

  def number_of_io_elements(avl_data, position)
    avl_data[position..position + 1].to_i(16)
  end

  def decode
    data = []

    if number_of_rec == number_of_total_rec
      index = 0
      position = 0

      while index < number_of_rec
        # Timestamp
        timestamp = timestamp(avl_data, position)
        position += 16

        # Priority
        priority = priority(avl_data, position)
        position += 2

        # Longitude
        longitude = longitude(avl_data, position)
        position += 8

        # Latitude
        latitude = latitude(avl_data, position)
        position += 8

        # Altitude
        altitude = altitude(avl_data, position)
        position += 4

        # Angle
        angle = angle(avl_data, position)
        position += 4

        # Satellites
        satellites = satellites(avl_data, position)
        position += 2

        # Speed
        speed = speed(avl_data, position)
        position += 4

        # SensorsData

        # IO element ID of Event generated
        io_event_code = avl_data[position..position + 1].to_i(16)
        position += 2

        number_of_io_elements = avl_data[position..position + 1].to_i(16)
        position += 2

        # 1 Bit
        number_of_io1_bit_elements = avl_data[position..position + 1].to_i(16)
        position += 2
        io_data = {}
        number_of_io1_bit_elements.times do
          io_code = avl_data[position..position + 1].to_i(16)
          position += 2
          io_val = avl_data[position..position + 1].to_i(16)
          position += 2
          io_data[io_code] = io_val
        end

        # 2 Bit
        number_of_io2_bit_elements = avl_data[position..position + 1].to_i(16)
        position += 2

        number_of_io2_bit_elements.times do
          io_code = avl_data[position..position + 1].to_i(16)
          position += 2
          io_val = avl_data[position..position + 3].to_i(16)
          position += 4
          io_data[io_code] = io_val
        end

        # 4 Bit
        number_of_io4_bit_elements = avl_data[position..position + 1].to_i(16)
        position += 2

        number_of_io4_bit_elements.times do
          io_code = avl_data[position..position + 1].to_i(16)
          position += 2
          io_val = avl_data[position..position + 7].to_i(16)
          position += 8
          io_data[io_code] = io_val
        end

        # 8 Bit
        number_of_io8_bit_elements = avl_data[position..position + 1].to_i(16)
        position += 2

        number_of_io8_bit_elements.times do
          io_code = avl_data[position..position + 1].to_i(16)
          position += 2
          io_val = avl_data[position..position + 15].to_i(16)
          position += 16
          io_data[io_code] = io_val
        end

        index += 1

        decoded_data = {
          imei: @imei,
          number_of_rec: number_of_rec,
          date_time: timestamp,
          priority: priority,
          gps_data: {
              longitude: longitude,
              latitude: latitude,
              altitude: altitude,
              angle: angle,
              satellites: satellites,
              speed: speed,
          },
          io_event_code: io_event_code,
          number_of_io_elements: number_of_io_elements,
          io_data: io_data
        }

        data << decoded_data
      end
    end

    return data
  end
end
