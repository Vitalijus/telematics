require './lib/data_decoder'
require 'date'

RSpec.describe DataDecoder do
  let(:imei) { "123456789012345" }
  let(:payload) { "00112233445566778899AABBCCDDEEFF00011223344556677889900" }
  let(:decoder) { DataDecoder.new(payload, imei) }

  describe '#initialize' do
    it 'sets the payload and imei' do
      expect(decoder.instance_variable_get(:@payload)).to eq(payload)
      expect(decoder.instance_variable_get(:@imei)).to eq(imei)
    end
  end

  describe '#number_of_rec' do
    it 'returns the number of records' do
      allow(payload).to receive(:[]).with(18..19).and_return("01")
      expect(decoder.number_of_rec).to eq(1)
    end
  end

  describe '#number_of_total_rec' do
    it 'returns the total number of records' do
      allow(payload).to receive(:[]).with(-10..-9).and_return("01")
      expect(decoder.number_of_total_rec).to eq(1)
    end
  end

  describe '#timestamp' do
    let(:avl_data) { "0000000166D1A32B000001" }

    it 'converts hex timestamp to human-readable format' do
      position = 0
      expected_time = "2022-01-01T00:00:00" # Example expected time
      allow(DateTime).to receive(:strptime).and_return(DateTime.parse(expected_time))
      expect(decoder.timestamp(avl_data, position)).to eq(expected_time)
    end
  end

  describe '#priority' do
    let(:avl_data) { "0000000166D1A32B000001" }

    it 'returns the priority as an integer' do
      position = 16
      allow(avl_data).to receive(:[]).with(position..position + 1).and_return("02")
      expect(decoder.priority(avl_data, position)).to eq(2)
    end
  end

  describe '#longitude' do
    let(:avl_data) { "0000000166D1A32B000001" }

    it 'converts hex longitude to a floating point value' do
      position = 18
      allow(avl_data).to receive(:[]).with(position..position + 7).and_return("01234567")
      expect(decoder.longitude(avl_data, position)).to eq(19088743 / 10000000.0)
    end
  end

  describe '#latitude' do
    let(:avl_data) { "0000000166D1A32B000001" }

    it 'converts hex latitude to a floating point value' do
      position = 26
      allow(avl_data).to receive(:[]).with(position..position + 7).and_return("89ABCDEF")
      expect(decoder.latitude(avl_data, position)).to eq(2309737967 / 10000000.0)
    end
  end

  describe '#decode' do
    let(:payload) do
      "0000000100000000166D1A32B" +  # Header (1 record, timestamp)
        "02" +                      # Priority
        "01234567" +                # Longitude
        "89ABCDEF" +                # Latitude
        "0000" +                    # Altitude
        "0001" +                    # Angle
        "02" +                      # Satellites
        "000A" +                    # Speed
        "03" +                      # IO Event Code
        "01" +                      # Number of IO Elements
        "01" +                      # Number of 1-Bit IO Elements
        "01" + "01" +               # 1-Bit IO Element (ID, Value)
        "01" + "0001" +             # 2-Bit IO Element
        "01" + "00000001" +         # 4-Bit IO Element
        "01" + "0000000000000001"   # 8-Bit IO Element
    end

    it 'decodes payload into meaningful data' do
      decoded = decoder.decode

      expect(decoded.size).to eq(1)
      expect(decoded.first[:imei]).to eq(imei)
      expect(decoded.first[:number_of_rec]).to eq(1)
      expect(decoded.first[:gps_data][:longitude]).to eq(19088743 / 10000000.0)
      expect(decoded.first[:gps_data][:latitude]).to eq(2309737967 / 10000000.0)
      expect(decoded.first[:gps_data][:altitude]).to eq(0)
      expect(decoded.first[:gps_data][:angle]).to eq(1)
      expect(decoded.first[:gps_data][:satellites]).to eq(2)
      expect(decoded.first[:gps_data][:speed]).to eq(10)
      expect(decoded.first[:io_event_code]).to eq(3)
      expect(decoded.first[:io_data]).to eq({ 1 => 1, 2 => 1, 3 => 1, 4 => 1 })
    end
  end
end
