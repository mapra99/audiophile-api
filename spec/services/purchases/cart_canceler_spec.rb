require 'rails_helper'

RSpec.describe Purchases::CartCanceler do
  subject(:canceler) { described_class.new(cart_uuid: cart_uuid, session: session) }

  let(:session) { create(:session) }
  let(:cart) { create(:purchase_cart, status: cart_status, session: session) }
  let(:cart_uuid) { cart.uuid }
  let(:cart_status) { PurchaseCart::STARTED }

  describe '#call' do
    describe 'when successful' do
      before do
        canceler.call
      end

      it 'updates the cart status to canceled' do
        expect(cart.reload.status).to eq(PurchaseCart::CANCELED)
      end
    end

    describe 'when cart is not found' do
      let(:cart_uuid) { '123abc' }

      it 'raises an error' do
        expect { canceler.call }.to raise_error(Purchases::CartNotFound)
      end
    end

    describe 'when cart is already paid' do
      let(:cart_status) { PurchaseCart::PAID }

      it 'raises an error' do
        expect { canceler.call }.to raise_error(Purchases::InvalidStatusForCancelation)
      end
    end
  end
end
