require 'rails_helper'

RSpec.describe Api::V1::Locations::Creator do
  subject(:creator) { described_class.new(params: params, user: user) }

  let(:user) { create(:user) }
  let(:params) do
    {
      street_address: 'Cra 7 # 24-89',
      city: 'Bogota',
      country: 'Colombia',
      postal_code: '110010',
      extra_info: 'Apt 1101'
    }
  end

  describe '#call' do
    subject(:result) { creator.call }

    describe 'when successful' do
      let(:location) { create(:colpatria_tower_co) }
      let(:location_creator) { instance_double(Locations::LocationCreator, call: true, location: location) }

      before do
        VCR.use_cassette('geocoder_response') do
          allow(Locations::LocationCreator).to receive(:new).and_return(location_creator)
        end
      end

      it 'succeeds' do
        expect(result.success?).to eq(true)
      end

      it 'calls the location creator' do
        creator.call
        expect(location_creator).to have_received(:call)
      end

      it 'returns the created user location' do
        expect(result.value!).to eq(user.user_locations.last)
      end
    end

    describe 'when location could not be created' do
      before do
        allow(Locations::LocationCreator).to receive(:new).and_raise(Locations::InvalidLocation.new(['error']))
      end

      it 'fails' do
        expect(result.failure?).to eq(true)
      end

      it 'returns an invalid location code' do
        expect(result.failure[:code]).to eq(:invalid_location)
      end
    end
  end
end
