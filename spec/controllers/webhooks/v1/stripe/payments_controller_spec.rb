require 'rails_helper'

RSpec.describe Webhooks::V1::Stripe::PaymentsController, type: :controller do
  render_views

  describe '#create' do
    let(:payment_event) { create(:payment_event, :created_intent) }
    let(:payment_handler) { instance_double(Webhooks::V1::Stripe::PaymentHandler, call: true) }

    before do
      allow(Webhooks::V1::Stripe::PaymentHandler).to receive(:new).and_return(payment_handler)

      post :create, body: payment_event.raw_data.to_json, format: :json
    end

    it 'returns success response' do
      expect(response.status).to eq 200
    end

    it 'calls the webhook handler' do
      expect(payment_handler).to have_received(:call)
    end

    describe 'when the handler raises an  error' do
      before do
        allow(Webhooks::V1::Stripe::PaymentHandler).to receive(:new).and_raise(StandardError.new('ERROR'))
      end

      it 'returns an error response' do
        expect(response.status).to eq 200
      end
    end
  end
end
