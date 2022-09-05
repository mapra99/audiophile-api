require 'rails_helper'

RSpec.describe Api::V1::PaymentsController, type: :controller do
  render_views

  describe '#create' do
    let(:user) { create(:user) }
    let(:purchase_cart) { create(:purchase_cart, user: user) }
    let(:created_payment) { create(:payment, purchase_cart: purchase_cart, user: user) }
    let(:created_intent) { { 'client_secret' => '123abc' } }

    let(:creator_result) { instance_double('Creator Result', success?: true, failure?: false, value!: nil) }
    let(:creator) do
      instance_double(
        Api::V1::Payments::Creator,
        call: creator_result,
        payment: created_payment,
        payment_intent: created_intent
      )
    end

    let(:access_token) { create(:access_token, user: user, status: AccessToken::ACTIVE) }

    before do
      allow(Api::V1::Payments::Creator).to receive(:new).and_return creator

      request.headers['X-AUDIOPHILE-KEY'] = 'audiophile'
      request.headers['Authorization'] = "Bearer #{access_token.token}"
      post :create, format: :json, params: { purchase_cart_uuid: purchase_cart.uuid }
    end

    it 'calls the payments creator' do
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

    describe 'when creator fails due to invalid payment' do
      let(:creator_result) do
        instance_double('Creator Result', success?: false, failure?: true,
                                          failure: { code: :invalid_payment, message: 'Validation error' })
      end

      it 'returns a 422 status' do
        expect(response.status).to eq 422
      end
    end

    describe 'when creator fails due to provider error' do
      let(:creator_result) do
        instance_double('Creator Result', success?: false, failure?: true,
                                          failure: { code: :provider_error, message: 'Error' })
      end

      it 'returns a 500 status' do
        expect(response.status).to eq 500
      end
    end

    describe 'when creator fails due to purchase cart not found' do
      let(:creator_result) do
        instance_double('Creator Result', success?: false, failure?: true,
                                          failure: { code: :purchase_cart_not_found, message: 'Error' })
      end

      it 'returns a 400 status' do
        expect(response.status).to eq 400
      end
    end

    describe 'when creator fails due to invalid purchase cart' do
      let(:creator_result) do
        instance_double('Creator Result', success?: false, failure?: true,
                                          failure: { code: :invalid_purchase_cart, message: 'Error' })
      end

      it 'returns a 400 status' do
        expect(response.status).to eq 400
      end
    end
  end
end
