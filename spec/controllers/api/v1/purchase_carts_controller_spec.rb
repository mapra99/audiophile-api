require 'rails_helper'

RSpec.describe Api::V1::PurchaseCartsController, type: :controller do
  render_views

  describe '#create' do
    let(:product_category) { create(:product_category) }
    let(:payload) do
      {
        items: [
          {
            stock_uuid: '123abc',
            quantity: 1
          }, {
            stock_uuid: '456def',
            quantity: 5
          }
        ]
      }
    end
    let(:created_product) { create(:purchase_cart) }
    let(:creator_result) do
      instance_double('Creator Result', success?: true, failure?: false, value!: created_product)
    end
    let(:creator) { instance_double(Api::V1::PurchaseCarts::Creator, call: creator_result) }

    before do
      allow(Api::V1::PurchaseCarts::Creator).to receive(:new).and_return creator

      request.headers['X-AUDIOPHILE-KEY'] = 'audiophile'
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

    describe 'when creator fails due to stock not found' do
      let(:creator_result) do
        instance_double('Creator Result', success?: false, failure?: true,
                                          failure: { code: :stock_not_found, message: 'stock not found' })
      end

      it 'returns a 400 status' do
        expect(response.status).to eq 400
      end
    end

    describe 'when creator fails due to insufficient stock' do
      let(:creator_result) do
        instance_double('Creator Result', success?: false, failure?: true,
                                          failure: { code: :insufficient_stock, message: 'Error' })
      end

      it 'returns a 422 status' do
        expect(response.status).to eq 422
      end
    end

    describe 'when creator fails due to invalid cart item' do
      let(:creator_result) do
        instance_double('Creator Result', success?: false, failure?: true,
                                          failure: { code: :invalid_cart_item, message: 'Error' })
      end

      it 'returns a 422 status' do
        expect(response.status).to eq 422
      end
    end

    describe 'when creator fails due to invalid extra fee' do
      let(:creator_result) do
        instance_double('Creator Result', success?: false, failure?: true,
                                          failure: { code: :invalid_extra_fee, message: 'Error' })
      end

      it 'returns a 422 status' do
        expect(response.status).to eq 422
      end
    end
  end

  describe '#destroy' do
    let(:cart) { create(:purchase_cart) }
    let(:destroyer_result) do
      instance_double('Destroyer Result', success?: true, failure?: false, value!: nil)
    end
    let(:destroyer) { instance_double(Api::V1::PurchaseCarts::Destroyer, call: destroyer_result) }

    before do
      allow(Api::V1::PurchaseCarts::Destroyer).to receive(:new).and_return destroyer

      request.headers['X-AUDIOPHILE-KEY'] = 'audiophile'
      delete :destroy, format: :json, params: { uuid: cart.uuid }
    end

    it 'calls the collection creator' do
      expect(destroyer).to have_received(:call)
    end

    it 'returns a 204 status' do
      expect(response.status).to eq 204
    end

    describe 'when destroyer fails due to internal error' do
      let(:destroyer_result) do
        instance_double('Destroyer Result', success?: false, failure?: true, failure: { code: :internal_error })
      end

      it 'returns a 500 status' do
        expect(response.status).to eq 500
      end
    end

    describe 'when destroyer fails due to cart not found' do
      let(:destroyer_result) do
        instance_double('Destroyer Result', success?: false, failure?: true,
                                            failure: { code: :cart_not_found, message: 'cart not found' })
      end

      it 'returns a 404 status' do
        expect(response.status).to eq 404
      end
    end

    describe 'when destroyer fails due to invalid status' do
      let(:destroyer_result) do
        instance_double('Destroyer Result', success?: false, failure?: true,
                                            failure: { code: :invalid_status, message: 'Error' })
      end

      it 'returns a 422 status' do
        expect(response.status).to eq 422
      end
    end
  end
end
