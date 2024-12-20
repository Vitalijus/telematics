require './lib/data_decoder'
require 'date'
require 'pry'

RSpec.describe DataDecoder do
  let(:payload) { "00000000000004cb0811000001820c370a70000ed84a7a209b648d009c01050e000e000e06ef01f0011504c8004501fa0105b50007b6000442369343102044000003f10000601ac70000002b10001b867900000001820c3725c8000ed8305f209b63e6009f01090e0018000e06ef01f0011504c8004501fa0105b50006b6000342369543102044000003f10000601ac70000002b10001b86a400000001820c373180000ed82590209b634000a101040e000d000e06ef01f0011504c8004501fa0105b50007b6000442367c43102044000003f10000601ac70000001210001b86b600000001820c373950000ed82155209b62aa00a300de0e0006000e06ef01f0011504c8004501fa0105b50006b6000442368243102044000003f10000601ac70000000710001b86bd00000001820c374120000ed8205b209b614c00a300c00e0008000e06ef01f0011504c8004501fa0105b50005b6000342368743102044000003f10000601ac70000000510001b86c200000001820c3748f0000ed81f50209b5f9a00a400ce0e0008000e06ef01f0011504c8004501fa0105b50007b6000442367343102044000003f10000601ac70000000210001b86c400000001820c374cd8000ed81e46209b5f3600a300e40d0006000e06ef01f0011504c8004501fa0105b50007b6000442367843102044000003f10000601ac70000000510001b86c900000001820c3750c0000ed81d4c209b5f0400a301080e0006000e06ef01f0011504c8004501fa0105b50007b6000442367943102044000003f10000601ac70000000010001b86c900000001820c375890000ed81a4d209b5f1500a101120e000a000e06ef01f0011504c8004501fa0105b50005b6000342368143102044000003f10000601ac70000000610001b86cf00000001820c376448000ed814a3209b5f5800a001060e000b000e06ef01f0011504c8004501fa0105b50007b6000442367d43102044000003f10000601ac70000000610001b86d500000001820c376c18000ed810bb209b5f26009f00fc0e000b000e06ef01f0011504c8004501fa0105b50007b6000442366f43102044000003f10000601ac70000000710001b86dc00000001820c377000000ed80f2b209b5ef4009f00f20e0007000e06ef01f0011504c8004501fa0105b50007b6000442367943102044000003f10000601ac70000000610001b86e200000001820c390640000ed80f1a209b5ed2009e00f20b0000f00e06ef01f0001504c8004501fa0105b50006b6000442315743102044000003f10000601ac70000000010001b86e200000001820c390a28000ed80f1a209b5ed2009e00f20b0000ef0e06ef00f0001504c8004501fa0105b50006b6000442315243102044000003f10000601ac70000000010001b86e200000001820c39ecb8000ed80f1a209b5ed2009b00f20d0000fa0e06ef00f0001504c8004501fa0005b50005b6000442319843102044000003f10000601ac70000000010001b86e200000001820c48bdb0000ed80f1a209b5ed2009200f20e0000000e06ef00f0001504c8004501fa0005b50005b6000342311343102044000003f10000601ac70000000010001b86e200000001820c48c580000ed81078209b5eb10092005a0e0000f00e06ef00f0011504c8004501fa0005b50005b600034230e943102044000003f10000601ac70000000010001b86e200110000a22f" }

  let(:imei) { "867909012345678" }
  let(:decoder) { DataDecoder.new(payload, imei) }

  describe '#decode' do
    it 'returns the correct imei' do
      decoded_data = decoder.decode
      expect(decoded_data.first[:imei]).to eq("867909012345678")
    end

    it 'returns the correct number of records' do
      decoded_data = decoder.decode
      expect(decoded_data.size).to eq(17)
    end

    it 'correctly decodes the first record timestamp' do
      decoded_data = decoder.decode
      expect(decoded_data.first[:date_time]).to eq("2022-07-17T12:51:50")
    end

    it 'correctly decodes priority' do
      decoded_data = decoder.decode
      expect(decoded_data.first[:priority]).to eq(0)
    end

    it 'parses GPS data correctly' do
      decoded_data = decoder.decode
      gps_data = decoded_data.first[:gps_data]

      expect(gps_data).not_to be_empty
      expect(gps_data[:longitude]).to eq(24.9055866)
      expect(gps_data[:latitude]).to eq(54.7054733)
      expect(gps_data[:altitude]).to eq(156)
      expect(gps_data[:angle]).to eq(261)
      expect(gps_data[:satellites]).to eq(14)
      expect(gps_data[:speed]).to eq(14)
    end

    it 'correctly decodes io_event_code' do
      decoded_data = decoder.decode
      expect(decoded_data.first[:io_event_code]).to eq(0)
    end

    it 'correctly decodes number_of_io_elements' do
      decoded_data = decoder.decode
      expect(decoded_data.first[:number_of_io_elements]).to eq(14)
    end

    it 'correctly parses IO data' do
      decoded_data = decoder.decode
      io_data = decoded_data.first[:io_data]
      expect(io_data.keys).to include(239, 240, 21, 200, 69, 250, 181, 182, 66, 67, 68, 241, 199, 16)
      expect(io_data[1]).to eq(nil)
    end
  end
end

# Decoded payload results example:
# [{:imei=>"357544374597827", :number_of_rec=>17, :date_time=>"2022-07-05T13:05:26", :priority=>0, :gps_data=>{:longitude=>24.4257566, :latitude=>58.8435066, :altitude=>32, :angle=>197, :satellites=>19, :speed=>99}, :io_event_code=>0, :number_of_io_elements=>14, :io_data=>{239=>1, 240=>1, 21=>4, 200=>0, 69=>1, 250=>1, 181=>5, 182=>2, 66=>13863, 67=>4066, 68=>0, 241=>24801, 199=>111, 16=>774626}}, {:imei=>"357544374597827", :number_of_rec=>17, :date_time=>"2022-07-05T13:05:30", :priority=>0, :gps_data=>{:longitude=>24.4252016, :latitude=>58.8425816, :altitude=>33, :angle=>197, :satellites=>19, :speed=>97}, :io_event_code=>0, :number_of_io_elements=>14, :io_data=>{239=>1, 240=>1, 21=>4, 200=>0, 69=>1, 250=>1, 181=>4, 182=>2, 66=>13859, 67=>4066, 68=>0, 241=>24801, 199=>107, 16=>774733}}, {:imei=>"357544374597827", :number_of_rec=>17, :date_time=>"2022-07-05T13:05:34", :priority=>0, :gps_data=>{:longitude=>24.4246566, :latitude=>58.8416783, :altitude=>33, :angle=>197, :satellites=>19, :speed=>95}, :io_event_code=>0, :number_of_io_elements=>14, :io_data=>{239=>1, 240=>1, 21=>4, 200=>0, 69=>1, 250=>1, 181=>5, 182=>2, 66=>13848, 67=>4066, 68=>0, 241=>24801, 199=>105, 16=>774838}}, {:imei=>"357544374597827", :number_of_rec=>17, :date_time=>"2022-07-05T13:05:38", :priority=>0, :gps_data=>{:longitude=>24.4241016, :latitude=>58.8407916, :altitude=>30, :angle=>197, :satellites=>18, :speed=>92}, :io_event_code=>0, :number_of_io_elements=>14, :io_data=>{239=>1, 240=>1, 21=>4, 200=>0, 69=>1, 250=>1, 181=>5, 182=>2, 66=>13843, 67=>4066, 68=>0, 241=>24801, 199=>104, 16=>774942}}, {:imei=>"357544374597827", :number_of_rec=>17, :date_time=>"2022-07-05T13:05:42", :priority=>0, :gps_data=>{:longitude=>24.4235516, :latitude=>58.8399133, :altitude=>29, :angle=>197, :satellites=>16, :speed=>90}, :io_event_code=>0, :number_of_io_elements=>14, :io_data=>{239=>1, 240=>1, 21=>3, 200=>0, 69=>1, 250=>1, 181=>4, 182=>3, 66=>13846, 67=>4066, 68=>0, 241=>24801, 199=>103, 16=>775045}}, {:imei=>"357544374597827", :number_of_rec=>17, :date_time=>"2022-07-05T13:05:47", :priority=>0, :gps_data=>{:longitude=>24.422915, :latitude=>58.8388483, :altitude=>30, :angle=>197, :satellites=>16, :speed=>89}, :io_event_code=>0, :number_of_io_elements=>14, :io_data=>{239=>1, 240=>1, 21=>3, 200=>0, 69=>1, 250=>1, 181=>5, 182=>3, 66=>13843, 67=>4066, 68=>0, 241=>24801, 199=>123, 16=>775168}}, {:imei=>"357544374597827", :number_of_rec=>17, :date_time=>"2022-07-05T13:05:52", :priority=>0, :gps_data=>{:longitude=>24.4222633, :latitude=>58.8377783, :altitude=>33, :angle=>197, :satellites=>17, :speed=>88}, :io_event_code=>0, :number_of_io_elements=>14, :io_data=>{239=>1, 240=>1, 21=>3, 200=>0, 69=>1, 250=>1, 181=>4, 182=>3, 66=>13850, 67=>4066, 68=>0, 241=>24801, 199=>125, 16=>775293}}, {:imei=>"357544374597827", :number_of_rec=>17, :date_time=>"2022-07-05T13:05:57", :priority=>0, :gps_data=>{:longitude=>24.4216666, :latitude=>58.8367316, :altitude=>29, :angle=>197, :satellites=>19, :speed=>86}, :io_event_code=>0, :number_of_io_elements=>14, :io_data=>{239=>1, 240=>1, 21=>3, 200=>0, 69=>1, 250=>1, 181=>5, 182=>2, 66=>13840, 67=>4066, 68=>0, 241=>24801, 199=>121, 16=>775414}}, {:imei=>"357544374597827", :number_of_rec=>17, :date_time=>"2022-07-05T13:06:02", :priority=>0, :gps_data=>{:longitude=>24.42104, :latitude=>58.8357233, :altitude=>32, :angle=>197, :satellites=>19, :speed=>85}, :io_event_code=>0, :number_of_io_elements=>14, :io_data=>{239=>1, 240=>1, 21=>3, 200=>0, 69=>1, 250=>1, 181=>5, 182=>2, 66=>13854, 67=>4066, 68=>0, 241=>24801, 199=>118, 16=>775532}}, {:imei=>"357544374597827", :number_of_rec=>17, :date_time=>"2022-07-05T13:06:07", :priority=>0, :gps_data=>{:longitude=>24.4204033, :latitude=>58.834715, :altitude=>34, :angle=>197, :satellites=>17, :speed=>85}, :io_event_code=>0, :number_of_io_elements=>14, :io_data=>{239=>1, 240=>1, 21=>3, 200=>0, 69=>1, 250=>1, 181=>5, 182=>3, 66=>13788, 67=>4061, 68=>0, 241=>24801, 199=>118, 16=>775650}}, {:imei=>"357544374597827", :number_of_rec=>17, :date_time=>"2022-07-05T13:06:12", :priority=>0, :gps_data=>{:longitude=>24.41977, :latitude=>58.8336816, :altitude=>31, :angle=>197, :satellites=>18, :speed=>87}, :io_event_code=>0, :number_of_io_elements=>14, :io_data=>{239=>1, 240=>1, 21=>3, 200=>0, 69=>1, 250=>1, 181=>5, 182=>2, 66=>13840, 67=>4066, 68=>0, 241=>24801, 199=>121, 16=>775771}}, {:imei=>"357544374597827", :number_of_rec=>17, :date_time=>"2022-07-05T13:06:17", :priority=>0, :gps_data=>{:longitude=>24.41911, :latitude=>58.832625, :altitude=>28, :angle=>197, :satellites=>17, :speed=>87}, :io_event_code=>0, :number_of_io_elements=>14, :io_data=>{239=>1, 240=>1, 21=>3, 200=>0, 69=>1, 250=>1, 181=>4, 182=>2, 66=>13843, 67=>4062, 68=>0, 241=>24801, 199=>123, 16=>775894}}, {:imei=>"357544374597827", :number_of_rec=>17, :date_time=>"2022-07-05T13:06:22", :priority=>0, :gps_data=>{:longitude=>24.4184616, :latitude=>58.83157, :altitude=>24, :angle=>198, :satellites=>15, :speed=>91}, :io_event_code=>0, :number_of_io_elements=>14, :io_data=>{239=>1, 240=>1, 21=>3, 200=>0, 69=>1, 250=>1, 181=>5, 182=>3, 66=>13848, 67=>4066, 68=>0, 241=>24801, 199=>123, 16=>776017}}, {:imei=>"357544374597827", :number_of_rec=>17, :date_time=>"2022-07-05T13:06:26", :priority=>0, :gps_data=>{:longitude=>24.4179183, :latitude=>58.8306816, :altitude=>22, :angle=>198, :satellites=>14, :speed=>93}, :io_event_code=>0, :number_of_io_elements=>14, :io_data=>{239=>1, 240=>1, 21=>3, 200=>0, 69=>1, 250=>1, 181=>6, 182=>3, 66=>13844, 67=>4067, 68=>0, 241=>24801, 199=>104, 16=>776121}}, {:imei=>"357544374597827", :number_of_rec=>17, :date_time=>"2022-07-05T13:06:30", :priority=>0, :gps_data=>{:longitude=>24.4173383, :latitude=>58.82979, :altitude=>25, :angle=>197, :satellites=>13, :speed=>94}, :io_event_code=>0, :number_of_io_elements=>14, :io_data=>{239=>1, 240=>1, 21=>3, 200=>0, 69=>1, 250=>1, 181=>5, 182=>3, 66=>13692, 67=>4065, 68=>0, 241=>24801, 199=>104, 16=>776225}}, {:imei=>"357544374597827", :number_of_rec=>17, :date_time=>"2022-07-05T13:06:34", :priority=>0, :gps_data=>{:longitude=>24.4168166, :latitude=>58.8289183, :altitude=>20, :angle=>198, :satellites=>12, :speed=>95}, :io_event_code=>0, :number_of_io_elements=>14, :io_data=>{239=>1, 240=>1, 21=>3, 200=>0, 69=>1, 250=>1, 181=>6, 182=>3, 66=>13853, 67=>4066, 68=>0, 241=>24801, 199=>102, 16=>776327}}, {:imei=>"357544374597827", :number_of_rec=>17, :date_time=>"2022-07-05T13:06:38", :priority=>0, :gps_data=>{:longitude=>24.4162416, :latitude=>58.82803, :altitude=>18, :angle=>196, :satellites=>12, :speed=>94}, :io_event_code=>0, :number_of_io_elements=>14, :io_data=>{239=>1, 240=>1, 21=>3, 200=>0, 69=>1, 250=>1, 181=>9, 182=>4, 66=>13846, 67=>4066, 68=>0, 241=>24801, 199=>104, 16=>776431}}]
