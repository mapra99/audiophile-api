require 'rails_helper'

RSpec.describe Api::V1::Payments::Creator do
  subject(:creator) { described_class.new(purchase_cart_uuid: purchase_cart_uuid, user: user) }

  let(:user) { create(:user) }
  let(:purchase_cart) { create(:purchase_cart, user: user, status: PurchaseCart::STARTED) }
  let(:purchase_cart_uuid) { purchase_cart.uuid }

  describe '#call' do
    subject(:result) { creator.call }

    let(:payment) { create(:payment, user: user, purchase_cart: purchase_cart) }
    let(:payment_intent) { { 'client_secret' => '123abc' } }

    let(:payment_starter) do
      instance_double(Payments::StartPayment, call: true, payment: payment, payment_intent: payment_intent)
    end

    describe 'when success' do
      before do
        allow(Payments::StartPayment).to receive(:new).and_return(payment_starter)
      end

      it 'succeeds' do
        expect(result.success?).to eq(true)
      end

      it 'calls payment starter service' do
        creator.call
        expect(payment_starter).to have_received(:call)
      end
    end

    describe 'when purchase cart is not found' do
      let(:purchase_cart_uuid) { '123' }

      it 'fails' do
        expect(result.success?).to eq false
      end

      it 'returns a cart not found error code' do
        expect(result.failure[:code]).to eq(:purchase_cart_not_found)
      end
    end

    describe 'when purchase cart is not in started status' do
      let(:purchase_cart) { create(:purchase_cart, user: user, status: PurchaseCart::PAID) }

      it 'fails' do
        expect(result.success?).to eq false
      end

      it 'returns an invalid cart error code' do
        expect(result.failure[:code]).to eq(:invalid_purchase_cart)
      end
    end

    describe 'when payment could not be created' do
      before do
        allow(Payments::StartPayment).to receive(:new).and_raise(Payments::InvalidPayment.new(["ERROR"]))
      end

      it 'fails' do
        expect(result.success?).to eq false
      end

      it 'returns an invalid payment error code' do
        expect(result.failure[:code]).to eq(:invalid_payment)
      end
    end

    describe 'when payment provider threw an error' do
      before do
        allow(Payments::StartPayment).to receive(:new).and_raise(Payments::ProviderError.new("ERROR"))
      end

      it 'fails' do
        expect(result.success?).to eq false
      end

      it 'returns an invalid payment error code' do
        expect(result.failure[:code]).to eq(:provider_error)
      end
    end
  end
end
