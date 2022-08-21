require 'rails_helper'

RSpec.describe Location, type: :model do
  subject(:location) { build(:location) }

  describe 'associations' do
    it { is_expected.to have_many(:user_locations) }
    it { is_expected.to have_many(:users) }
  end

  describe 'validations' do
    it { VCR.use_cassette('geocoder_response') { is_expected.to validate_presence_of(:street_address) } }
    it { VCR.use_cassette('geocoder_response') { is_expected.to validate_presence_of(:city) } }
    it { VCR.use_cassette('geocoder_response') { is_expected.to validate_presence_of(:country) } }
    it { VCR.use_cassette('geocoder_response') { is_expected.to validate_presence_of(:postal_code) } }
  end

  describe '#full_address' do
    subject(:full_address) { location.full_address }

    let(:location) { build(:colpatria_tower_co) }

    it "returns the location's full address" do
      expect(full_address).to eq('Cra 7 # 24-89 Bogota Colombia 110010')
    end
  end

  describe '#geocode_address' do
    let(:location) { build(:colpatria_tower_co) }

    describe 'when location is already geocoded' do
      let(:location) { build(:colpatria_tower_co, longitude: 1, latitude: 1) }

      before do
        location.geocode_address
      end

      it 'does nothing' do
        expect([location.longitude, location.latitude]).to eq([1.0, 1.0])
      end
    end

    describe 'when location is not geocoded' do
      before do
        VCR.use_cassette('geocoder_response') do
          location.geocode_address
        end
      end

      it 'sets the location longitude' do
        expect(location.longitude).not_to be_nil
      end

      it 'sets the location latitude' do
        expect(location.latitude).not_to be_nil
      end
    end

    describe 'when location is not found' do
      before do
        allow(Geocoder).to receive(:search).and_return([])

        location.geocode_address
      end

      it 'does nothing' do
        expect([location.longitude, location.latitude]).to eq([nil, nil])
      end
    end
  end
end
