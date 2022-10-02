require 'rails_helper'

RSpec.describe Payments::FailureDispatch do
  subject(:dispatch) { described_class.new(payment: payment) }

  let(:payment) { create(:payment, status: Payment::STARTED) }

  describe '#call' do
    before do
      dispatch.call
    end

    it 'updates the payment status' do
      expect(payment.status).to eq(Payment::CANCELED)
    end
  end
end
