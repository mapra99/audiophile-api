require 'rails_helper'

RSpec.describe Payments::StartPayment do
  subject(:starter) { described_class.new(purchase_cart: purchase_cart, user: user) }

  let(:user) { create(:user) }
  let(:purchase_cart) { create(:purchase_cart, status: PurchaseCart::STARTED) }

  describe '#call' do
    subject(:result) { starter.call }

    let(:payment_intent) { { 'id' => '123abc' } }
    let(:stripe_intent_creator) do
      instance_double(Payments::Stripe::PaymentIntentCreator, call: true, payment_intent: payment_intent)
    end

    before do
      allow(Payments::Stripe::PaymentIntentCreator).to receive(:new).and_return(stripe_intent_creator)
    end

    it 'calls stripe payment intent creator' do
      starter.call
      expect(stripe_intent_creator).to have_received(:call)
    end

    it 'creates a payment record' do
      expect { starter.call }.to change(Payment, :count).by(1)
    end

    describe 'when payment could not be created' do
      let(:payment_intent) { { 'id' => nil } }

      it 'raises an error' do
        expect { starter.call }.to raise_error(Payments::InvalidPayment)
      end
    end
  end
end
