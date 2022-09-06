require 'rails_helper'

RSpec.describe Webhooks::V1::Stripe::PaymentHandler do
  subject(:handler) { described_class.new(body: body) }

  let(:body) { JSON.parse(build(:payment_event, :created_intent).raw_data.to_json) }

  describe '#call' do
    before do
      create(:payment, provider_id: 'pi_3Leos3LUUobuK6Uj1s2JY7yR')
    end

    it 'saves the payment event' do
      expect { handler.call }.to change(PaymentEvent, :count).by(1)
    end
  end
end
