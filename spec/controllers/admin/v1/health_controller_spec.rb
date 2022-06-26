require 'rails_helper'

RSpec.describe Admin::V1::HealthController, type: :controller do
  render_views

  describe '#show' do
    before do
      request.headers['X-ADMIN-KEY'] = 'admin'
      get :show, format: :json
    end

    it 'succeeds' do
      expect(response).to have_http_status(:ok)
    end

    it 'returns a health ok message' do
      expect(JSON.parse(response.body)['health']).to eq 'ok'
    end
  end
end
