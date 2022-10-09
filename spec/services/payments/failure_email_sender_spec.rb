require 'rails_helper'

RSpec.describe Payments::FailureEmailSender do
  subject(:sender) { described_class.new(payment: payment) }

  let(:payment) { create(:payment, status: Payment::CANCELED) }

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
