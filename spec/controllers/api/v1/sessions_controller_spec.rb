require 'rails_helper'

RSpec.describe Api::V1::SessionsController, type: :controller do
  render_views

  describe '#create' do
    let(:created_session) { create(:session) }
    let(:creator_result) do
      instance_double('Creator Result', success?: true, failure?: false, value!: created_session)
    end
    let(:creator) { instance_double(Api::V1::Sessions::Creator, call: creator_result) }

    before do
      allow(Api::V1::Sessions::Creator).to receive(:new).and_return creator

      request.headers['X-AUDIOPHILE-KEY'] = 'audiophile'
      post :create, format: :json
    end

    it 'calls the sessions creator' do
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

    describe 'when creator fails due to invalid session' do
      let(:creator_result) do
        instance_double('Creator Result', success?: false, failure?: true,
                                          failure: { code: :invalid_session, message: 'Validation error' })
      end

      it 'returns a 422 status' do
        expect(response.status).to eq 422
      end
    end
  end
end
