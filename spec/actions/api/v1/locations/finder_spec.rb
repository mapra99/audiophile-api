require 'rails_helper'

RSpec.describe Api::V1::Locations::Finder do
  subject(:finder) { described_class.new(user_location_uuid: user_location_uuid, user: user) }

  let(:location) do
    VCR.use_cassette('geocoder_response') do
      create(:colpatria_tower_co)
    end
  end
  let(:user) { create(:user) }
  let(:user_location) { create(:user_location, location: location, user: user) }
  let(:user_location_uuid) { user_location.uuid }

  describe '#call' do
    subject(:result) { finder.call }

    it 'returns the user location' do
      expect(result.value!).to eq(user_location)
    end

    describe 'when location is not found' do
      let(:user_location_uuid) { 'abc123' }

      it 'fails' do
        expect(result.success?).to eq(false)
      end

      it 'returns a location_not_found code' do
        expect(result.failure[:code]).to eq(:location_not_found)
      end
    end
  end
end
