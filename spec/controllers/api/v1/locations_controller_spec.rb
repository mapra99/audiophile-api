require 'rails_helper'

RSpec.describe Api::V1::LocationsController, type: :controller do
  render_views

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
end
