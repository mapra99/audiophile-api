require 'rails_helper'

RSpec.describe Admin::V1::ProductCategoriesController, type: :controller do
  render_views

  describe '#create' do
    let(:payload) do
      {
        name: 'Headphonez',
        image: fixture_file_upload('product_image.png', 'image/png')
      }
    end
    let(:created_category) { create(:product_category) }
    let(:creator_result) do
      instance_double('Creator Result', success?: true, failure?: false, value!: created_category)
    end
    let(:creator) { instance_double(Admin::V1::ProductCategories::Creator, call: creator_result) }

    before do
      allow(Admin::V1::ProductCategories::Creator).to receive(:new).and_return creator

      request.headers['X-ADMIN-KEY'] = 'admin'
      post :create, format: :json, params: payload
    end

    it 'calls the collection creator' do
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

    describe 'when creator fails due to validation error' do
      let(:creator_result) do
        instance_double('Creator Result', success?: false, failure?: true,
                                          failure: { code: :invalid_product_category, message: ['Error'] })
      end

      it 'returns a 422 status' do
        expect(response.status).to eq 422
      end
    end

    describe 'when creator fails due to product category not saved' do
      let(:creator_result) do
        instance_double('Creator Result', success?: false, failure?: true, failure: { code: :product_category_not_saved })
      end

      it 'returns a 500 status' do
        expect(response.status).to eq 500
      end
    end

    describe 'when not authenticated' do
      before do
        request.headers['X-ADMIN-KEY'] = nil
        post :create, format: :json, params: payload
      end

      it 'returns a 401 error' do
        expect(response.status).to eq 401
      end
    end
  end
end
