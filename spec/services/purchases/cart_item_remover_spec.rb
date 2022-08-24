require 'rails_helper'

RSpec.describe Purchases::CartItemRemover do
  subject(:remover) { described_class.new(item_uuid: item_uuid, session: session) }

  let(:session) { create(:session) }
  let(:cart) { create(:purchase_cart, session: session) }
  let(:cart_item) { create(:purchase_cart_item, purchase_cart: cart) }
  let(:item_uuid) { cart_item.uuid }

  describe '#call' do
    describe 'when successful' do
      before do
        remover.call
      end

      it 'removes the item from the db' do
        expect(PurchaseCartItem.find_by(uuid: item_uuid)).to be_nil
      end

      it 'updates the cart price' do
        expect(cart.reload.total_price).to eq(0)
      end
    end

    describe 'when cart item is not found' do
      before do
        allow(PurchaseCartItem).to receive(:find_by).and_return(nil)
      end

      it 'fails' do
        expect { remover.call }.to raise_error(Purchases::CartItemNotFound)
      end
    end
  end
end
