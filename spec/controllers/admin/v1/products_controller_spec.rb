require 'rails_helper'

RSpec.describe Admin::V1::ProductsController, type: :controller do
  render_views

  describe '#index' do
    let(:products) { create_list(:product, 2) }
    let(:builder_result) do
      instance_double('CollectionBuilder Result', success?: true, failure?: false, value!: products)
    end
    let(:collection_builder) { instance_double(Admin::V1::Products::CollectionBuilder, call: builder_result) }

    before do
      allow(Admin::V1::Products::CollectionBuilder).to receive(:new).and_return collection_builder

      request.headers['X-ADMIN-KEY'] = 'admin'
      get :index, format: :json
    end

    it 'calls the collection builder service' do
      expect(collection_builder).to have_received(:call)
    end

    it 'returns a 200 status' do
      expect(response.status).to eq 200
    end

    describe 'when builder fails' do
      let(:builder_result) do
        instance_double('CollectionBuilder Result', success?: false, failure?: true, failure: { code: :internal_error })
      end

      it 'returns a 500 status' do
        expect(response.status).to eq 500
      end
    end

    describe 'when not authenticated' do
      before do
        request.headers['X-ADMIN-KEY'] = nil
        get :index, format: :json
      end

      it 'returns a 401 error' do
        expect(response.status).to eq 401
      end
    end
  end

  describe '#create' do
    let(:product_category) { create(:product_category) }
    let(:payload) do
      {
        product: {
          name: 'Some Product',
          price: 450,
          featured: false,
          category_id: product_category.id
        }
      }
    end
    let(:created_product) { create(:product) }
    let(:creator_result) do
      instance_double('Creator Result', success?: true, failure?: false, value!: created_product)
    end
    let(:creator) { instance_double(Admin::V1::Products::Creator, call: creator_result) }

    before do
      allow(Admin::V1::Products::Creator).to receive(:new).and_return creator

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

    describe 'when creator fails due to category not found' do
      let(:creator_result) do
        instance_double('Creator Result', success?: false, failure?: true, failure: { code: :category_not_found })
      end

      it 'returns a 400 status' do
        expect(response.status).to eq 400
      end
    end

    describe 'when creator fails due to validation error' do
      let(:creator_result) do
        instance_double('Creator Result', success?: false, failure?: true, failure: { code: :invalid_product, message: ["Error"] })
      end

      it 'returns a 422 status' do
        expect(response.status).to eq 422
      end
    end

    describe 'when creator fails due to product not saved' do
      let(:creator_result) do
        instance_double('Creator Result', success?: false, failure?: true, failure: { code: :product_not_saved })
      end

      it 'returns a 500 status' do
        expect(response.status).to eq 500
      end
    end
  end
end
