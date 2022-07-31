require 'rails_helper'

RSpec.describe Purchases::ExtraFeesGenerator do
  subject(:generator) { described_class.new(cart: cart) }

  let(:cart) { create(:purchase_cart) }

  describe '#call' do
    subject(:result) { generator.call }

    describe 'when success' do
      before do
        generator.call
      end

      it 'creates the shipping fee' do
        expect(cart.purchase_cart_extra_fees.first.key).to eq('shipping')
      end

      it 'updates the cart price' do
        expect(cart.total_price).to eq(Purchases::ExtraFeesGenerator::SHIPPING_PRICE)
      end
    end

    describe 'when passing cart uuid' do
      subject(:generator) { described_class.new(cart_uuid: cart.uuid) }

      before do
        allow(PurchaseCart).to receive(:find_by).and_return(cart)
        generator.call
      end

      it 'looks up the cart' do
        expect(PurchaseCart).to have_received(:find_by).with(uuid: cart.uuid)
      end
    end

    describe 'when passing cart uuid and its not found' do
      let(:generator) { described_class.new(cart_uuid: cart.uuid) }

      before do
        allow(PurchaseCart).to receive(:find_by).and_raise(Purchases::CartNotFound.new(anything))
      end

      it 'throws an error' do
        expect { result }.to raise_error(Purchases::CartNotFound)
      end
    end
  end
end
