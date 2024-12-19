require './lib/trackers_data.rb'

RSpec.describe TrackersData do
  let(:calculator) { TrackersData.new }

  describe '#add' do
    it 'returns the sum of two numbers' do
      expect(calculator.add(2, 3)).to eq(5)
    end
  end
end
