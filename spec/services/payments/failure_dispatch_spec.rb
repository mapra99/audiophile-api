require 'rails_helper'

RSpec.describe Payments::FailureDispatch do
  subject(:dispatch) { described_class.new(payment: payment) }

  let(:payment) { create(:payment, status: Payment::STARTED) }
  let(:failure_email_sender) { instance_double(Payments::FailureEmailSender, call: true) }

  describe '#call' do
    before do
      allow(Payments::FailureEmailSender).to receive(:new).and_return(failure_email_sender)

      dispatch.call
    end

    it 'updates the payment status' do
      expect(payment.status).to eq(Payment::CANCELED)
    end

    it 'calls the failed email sender' do
      expect(failure_email_sender).to have_received(:call)
    end
  end
end
