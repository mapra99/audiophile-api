require 'rails_helper'

RSpec.describe Admin::V1::StocksController, type: :controller do
  render_views

  describe '#create' do
    let(:product) { create(:product) }
    let(:payload) do
      {
        product_id: product.id,
        quantity: 5,
        toppings: [
          {
            key: 'color',
            value: 'blue',
            price_change: '+100'
          }, {
            key: 'size',
            value: 'L',
            price_change: '+10'
          }
        ]
      }
    end
    let(:created_stock) { create(:stock) }
    let(:creator_result) do
      instance_double('Creator Result', success?: true, failure?: false, value!: created_stock)
    end
    let(:creator) { instance_double(Admin::V1::Stocks::Creator, call: creator_result) }

    before do
      allow(Admin::V1::Stocks::Creator).to receive(:new).and_return creator

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

    describe 'when creator fails due to product not found' do
      let(:creator_result) do
        instance_double('Creator Result', success?: false, failure?: true, failure: { code: :product_not_found })
      end

      it 'returns a 400 status' do
        expect(response.status).to eq 400
      end
    end

    describe 'when creator fails due to invalid stock error' do
      let(:creator_result) do
        instance_double('Creator Result', success?: false, failure?: true,
                                          failure: { code: :invalid_stock, message: ['Error'] })
      end

      it 'returns a 422 status' do
        expect(response.status).to eq 422
      end
    end

    describe 'when creator fails due to invalid toppings error' do
      let(:creator_result) do
        instance_double('Creator Result', success?: false, failure?: true,
                                          failure: { code: :invalid_toppings, message: ['Error'] })
      end

      it 'returns a 422 status' do
        expect(response.status).to eq 422
      end
    end

    describe 'when creator fails due to stock not saved' do
      let(:creator_result) do
        instance_double('Creator Result', success?: false, failure?: true, failure: { code: :stock_not_saved })
      end

      it 'returns a 500 status' do
        expect(response.status).to eq 500
      end
    end
  end

  describe '#index' do
    let(:product) { create(:product) }
    let(:stocks) { create_list(:stock, 2, product: product) }
    let(:builder_result) do
      instance_double('CollectionBuilder Result', success?: true, failure?: false, value!: stocks)
    end
    let(:collection_builder) { instance_double(Admin::V1::Stocks::CollectionBuilder, call: builder_result) }

    before do
      allow(Admin::V1::Stocks::CollectionBuilder).to receive(:new).and_return collection_builder

      request.headers['X-ADMIN-KEY'] = 'admin'
      get :index, format: :json, params: { product_id: product.id }
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
        get :index, format: :json, params: { product_id: product.id }
      end

      it 'returns a 401 error' do
        expect(response.status).to eq 401
      end
    end
  end
end
