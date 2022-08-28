require 'rails_helper'

RSpec.describe Locations::LocationCreator do
  subject(:location_creator) do
    described_class.new(street_address: street_address, city: city, country: country, postal_code: postal_code)
  end

  let(:street_address) { 'Cra 7 # 24-89' }
  let(:city) { 'Bogota' }
  let(:country) { 'Colombia' }
  let(:postal_code) { '110010' }

  describe '#call' do
    describe 'when location is totally new' do
      before do
        VCR.use_cassette('geocoder_response') do
          location_creator.call
        end
      end

      it 'saves the location' do
        expect(Location.last.full_address).to eq('Cra 7 # 24-89 Bogota Colombia 110010')
      end
    end

    describe 'when location exists already in db' do
      before do
        VCR.use_cassette('geocoder_response') do
          create(:colpatria_tower_co)
        end
      end

      it 'does not save a new location' do
        VCR.use_cassette('geocoder_response') do
          expect { location_creator.call }.not_to change(Location, :count)
        end
      end
    end

    describe 'when location is not valid' do
      let(:street_address) { nil }

      it 'raises an error' do
        VCR.use_cassette('geocoder_response', match_requests_on: %i[method host path]) do
          expect { location_creator.call }.to raise_error(Locations::InvalidLocation)
        end
      end
    end
  end
end
