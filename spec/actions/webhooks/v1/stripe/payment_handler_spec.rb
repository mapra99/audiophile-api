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

    describe 'when payment event is a successful payment' do
      let(:body) { JSON.parse(build(:payment_event, :succeeded_intent).raw_data.to_json) }
      let(:success_dispatch) { instance_double(Payments::SuccessDispatch, call: true) }

      before do
        create(:payment, provider_id: 'pi_3Leop4LUUobuK6Uj1OfuNFxD')
        allow(Payments::SuccessDispatch).to receive(:new).and_return(success_dispatch)
      end

      it 'calls the success handler' do
        handler.call

        expect(success_dispatch).to have_received(:call)
      end
    end

    describe 'when payment event is a failed payment' do
      let(:body) { JSON.parse(build(:payment_event, :failed_intent).raw_data.to_json) }
      let(:failure_dispatch) { instance_double(Payments::FailureDispatch, call: true) }

      before do
        create(:payment, provider_id: 'pi_3Ler6NLUUobuK6Uj1kYhTH2O')
        allow(Payments::FailureDispatch).to receive(:new).and_return(failure_dispatch)
      end

      it 'calls the success handler' do
        handler.call

        expect(failure_dispatch).to have_received(:call)
      end
    end
  end
end
