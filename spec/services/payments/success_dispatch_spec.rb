require 'rails_helper'

RSpec.describe Payments::SuccessDispatch do
  subject(:dispatch) { described_class.new(payment: payment) }

  let(:payment) { create(:payment, purchase_cart: purchase_cart) }
  let(:purchase_cart) { create(:purchase_cart) }

  let(:order_starter) { instance_double(Orders::StartOrder, call: true, order: anything) }
  let(:success_email_sender) { instance_double(Payments::SuccessEmailSender, call: true) }

  describe '#call' do
    before do
      allow(Orders::StartOrder).to receive(:new).and_return(order_starter)
      allow(Payments::SuccessEmailSender).to receive(:new).and_return(success_email_sender)

      dispatch.call
    end

    it 'updates the payment status' do
      expect(payment.status).to eq(Payment::COMPLETED)
    end

    it 'updates the cart status' do
      expect(purchase_cart.status).to eq(PurchaseCart::PAID)
    end

    it 'calls the order starter' do
      expect(order_starter).to have_received(:call)
    end

    it 'calls the success email sender' do
      expect(success_email_sender).to have_received(:call)
    end
  end
end
