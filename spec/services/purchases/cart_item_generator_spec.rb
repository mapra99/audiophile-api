require 'rails_helper'

RSpec.describe Purchases::CartItemGenerator do
  subject(:generator) do
    described_class.new(
      stock_uuid: stock_uuid,
      quantity: quantity,
      cart: cart,
      cart_uuid: cart_uuid,
      session: session
    )
  end

  let(:cart) { create(:purchase_cart) }
  let(:stock) { create(:stock, quantity: stock_quantity) }
  let(:stock_quantity) { 10 }
  let(:quantity) { 5 }
  let(:stock_uuid) { stock.uuid }
  let(:cart_uuid) { nil }
  let(:session) { nil }

  describe '#call' do
    describe 'when successful' do
      before do
        generator.call
      end

      it 'creates the cart item' do
        expect(cart.purchase_cart_items.count).to eq(1)
      end

      it 'updates the cart price' do
        expect(cart.total_price).to eq(cart.purchase_cart_items.first.total_price)
      end
    end

    describe 'when passing cart_uuid instead of cart' do
      let(:cart) { nil }
      let(:cart_uuid) { target_cart.uuid }
      let(:target_cart) { create(:purchase_cart, session: session) }
      let(:session) { create(:session) }

      before do
        generator.call
      end

      it 'creates the cart item for the right cart' do
        expect(target_cart.purchase_cart_items.count).to eq(1)
      end
    end

    describe 'when there is not enough stocks' do
      let(:stock_quantity) { 5 }
      let(:quantity) { 6 }

      it 'raises an error' do
        expect { generator.call }.to raise_error(Purchases::InsufficientStock)
      end
    end
  end
end
