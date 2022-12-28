require 'rails_helper'

RSpec.describe Api::V1::LocationsController, type: :controller do
  render_views

  describe '#index' do
    let(:location) { create(:colpatria_tower_co) }
    let(:user) { create(:user) }
    let(:user_location) { create(:user_location, location: location, user: user) }

    let(:collection_result) do
      instance_double('Collection Result', success?: true, failure?: false, value!: [user_location])
    end
    let(:collection_builder) { instance_double(Api::V1::Locations::CollectionBuilder, call: collection_result) }

    let(:access_token) { create(:access_token, user: user, status: AccessToken::ACTIVE) }

    before do
      VCR.use_cassette('geocoder_response') do
        allow(Api::V1::Locations::CollectionBuilder).to receive(:new).and_return collection_builder
      end

      request.headers['X-AUDIOPHILE-KEY'] = 'audiophile'
      request.headers['Authorization'] = "Bearer #{access_token.token}"
      get :index, format: :json
    end

    it 'calls the locations collection builder' do
      expect(collection_builder).to have_received(:call)
    end

    it 'returns a 200 status' do
      expect(response.status).to eq 200
    end

    describe 'when collection builder fails due to internal error' do
      let(:collection_result) do
        instance_double('Collection Result', success?: false, failure?: true, failure: { code: :internal_error })
      end

      it 'returns a 500 status' do
        expect(response.status).to eq 500
      end
    end
  end

  describe '#create' do
    let(:location) { create(:colpatria_tower_co) }
    let(:user) { create(:user) }
    let(:created_user_location) { create(:user_location, location: location, user: user) }

    let(:payload) do
      {
        street_address: 'Cra 7 # 24-89',
        city: 'Bogota',
        country: 'Colombia',
        postal_code: '110010',
        extra_info: 'Apt 1101'
      }
    end

    let(:creator_result) do
      instance_double('Creator Result', success?: true, failure?: false, value!: created_user_location)
    end
    let(:creator) { instance_double(Api::V1::Locations::Creator, call: creator_result) }

    let(:access_token) { create(:access_token, user: user, status: AccessToken::ACTIVE) }

    before do
      VCR.use_cassette('geocoder_response') do
        allow(Api::V1::Locations::Creator).to receive(:new).and_return creator
      end

      request.headers['X-AUDIOPHILE-KEY'] = 'audiophile'
      request.headers['Authorization'] = "Bearer #{access_token.token}"
      post :create, format: :json, params: payload
    end

    it 'calls the locations creator' do
      expect(creator).to have_received(:call)
    end

    it 'returns a 200 status' do
      expect(response.status).to eq 200
    end

    describe 'when creator fails due to internal error' do
      let(:creator_result) do
        instance_double('Creator Result', success?: false, failure?: true, failure: { code: :internal_error })
      end

      it 'returns a 500 status' do
        expect(response.status).to eq 500
      end
    end

    describe 'when creator fails due to invalid location' do
      let(:creator_result) do
        instance_double('Creator Result', success?: false, failure?: true,
                                          failure: { code: :invalid_location, message: 'Validation error' })
      end

      it 'returns a 422 status' do
        expect(response.status).to eq 422
      end
    end
  end

  describe '#show' do
    let(:location) do
      VCR.use_cassette('geocoder_response') do
        create(:colpatria_tower_co)
      end
    end
    let(:user) { create(:user) }
    let(:user_location) { create(:user_location, location: location, user: user) }

    let(:finder_result) do
      instance_double('Finder Result', success?: true, failure?: false, value!: user_location)
    end
    let(:finder) { instance_double(Api::V1::Locations::Finder, call: finder_result) }

    let(:access_token) { create(:access_token, user: user, status: AccessToken::ACTIVE) }

    before do
      allow(Api::V1::Locations::Finder).to receive(:new).and_return finder

      request.headers['X-AUDIOPHILE-KEY'] = 'audiophile'
      request.headers['Authorization'] = "Bearer #{access_token.token}"
      get :show, format: :json, params: { uuid: user_location.uuid }
    end

    it 'calls the locations finder' do
      expect(finder).to have_received(:call)
    end

    it 'returns a 200 status' do
      expect(response.status).to eq 200
    end

    describe 'when finder fails due to location not found' do
      let(:finder_result) do
        instance_double('Finder Result', success?: false, failure?: true, failure: { code: :location_not_found })
      end

      it 'returns a 400 status' do
        expect(response.status).to eq 400
      end
    end

    describe 'when finder fails due to internal error' do
      let(:finder_result) do
        instance_double('Finder Result', success?: false, failure?: true, failure: { code: :internal_error })
      end

      it 'returns a 500 status' do
        expect(response.status).to eq 500
      end
    end
  end

  describe '#destroy' do
    let(:location) do
      VCR.use_cassette('geocoder_response') do
        create(:colpatria_tower_co)
      end
    end
    let(:user) { create(:user) }
    let(:user_location) { create(:user_location, location: location, user: user) }

    let(:destroyer_result) do
      instance_double('Destroyer Result', success?: true, failure?: false, value!: true)
    end
    let(:destroyer) { instance_double(Api::V1::Locations::Destroyer, call: destroyer_result) }

    let(:access_token) { create(:access_token, user: user, status: AccessToken::ACTIVE) }

    before do
      allow(Api::V1::Locations::Destroyer).to receive(:new).and_return destroyer

      request.headers['X-AUDIOPHILE-KEY'] = 'audiophile'
      request.headers['Authorization'] = "Bearer #{access_token.token}"
      delete :destroy, format: :json, params: { uuid: user_location.uuid }
    end

    it 'calls the locations destroyer' do
      expect(destroyer).to have_received(:call)
    end

    it 'returns a 204 status' do
      expect(response.status).to eq 204
    end

    describe 'when finder fails due to location not found' do
      let(:destroyer_result) do
        instance_double('Destroyer Result', success?: false, failure?: true, failure: { code: :location_not_found })
      end

      it 'returns a 400 status' do
        expect(response.status).to eq 400
      end
    end

    describe 'when finder fails due to internal error' do
      let(:destroyer_result) do
        instance_double('Destroyer Result', success?: false, failure?: true, failure: { code: :internal_error })
      end

      it 'returns a 500 status' do
        expect(response.status).to eq 500
      end
    end
  end
end
