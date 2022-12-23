require 'rails_helper'

RSpec.describe Api::V1::PageViewsController, type: :controller do
  render_views

  describe '#create' do
    let(:session) { create(:session) }
    let(:created_page_view) { create(:page_view, session: session) }
    let(:creator_result) do
      instance_double('Creator Result', success?: true, failure?: false, value!: created_page_view)
    end
    let(:creator) { instance_double(Api::V1::Sessions::Creator, call: creator_result) }

    before do
      allow(Api::V1::PageViews::Creator).to receive(:new).and_return creator

      request.headers['X-SESSION-ID'] = session.uuid
      request.headers['X-AUDIOPHILE-KEY'] = 'audiophile'

      post :create, format: :json
    end

    it 'calls the sessions creator' do
      expect(creator).to have_received(:call)
    end

    it 'returns a 204 status' do
      expect(response.status).to eq 204
    end

    describe 'when creator fails due to internal error' do
      let(:creator_result) do
        instance_double('Creator Result', success?: false, failure?: true, failure: { code: :internal_error })
      end

      it 'returns a 500 status' do
        expect(response.status).to eq 500
      end
    end
  end
end
