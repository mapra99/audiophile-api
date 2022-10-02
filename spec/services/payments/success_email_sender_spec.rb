require 'rails_helper'

RSpec.describe Payments::SuccessEmailSender do
  subject(:sender) { described_class.new(payment: payment, order: order) }

  let(:payment) { create(:payment, status: Payment::COMPLETED) }
  let(:order) do
    VCR.use_cassette('geocoder_response', match_requests_on: %i[method host path]) do
      create(:order, payment: payment, status: Order::ACTIVE)
    end
  end

  describe '#call' do
    before do
      allow(Communications::EmailSenderJob).to receive(:perform_later).and_return(true)

      sender.call
    end

    it 'sends the email' do
      expect(Communications::EmailSenderJob).to have_received(:perform_later)
    end
  end
end
