require 'rails_helper'

RSpec.describe Api::V1::Payments::CollectionBuilder do
  subject(:collection_builder) { described_class.new(user: user, purchase_cart_uuid: cart_uuid) }

  let(:user) { create(:user) }
  let(:cart_uuid) { nil }

  describe '#call' do
    subject(:result) { collection_builder.call }

    describe 'when successful' do
      before do
        create_list(:payment, 2)
        create_list(:payment, 5, user: user)
      end

      it 'succeeds' do
        expect(result.success?).to eq(true)
      end

      it 'returns the user payments' do
        expect(result.value!.length).to eq(5)
      end
    end

    describe 'when cart_uuid is present' do
      let(:cart) { create(:purchase_cart, user: user) }
      let(:cart_uuid) { cart.uuid }

      before do
        create_list(:payment, 5, user: user)
        create_list(:payment, 2, user: user, purchase_cart: cart)
      end

      it 'succeeds' do
        expect(result.success?).to eq(true)
      end

      it 'returns the user payments that belong to the given cart' do
        expect(result.value!.length).to eq(2)
      end
    end

    describe 'when cart is not found' do
      let(:cart) { create(:purchase_cart, user: user) }
      let(:cart_uuid) { "123abc" }

      before do
        create_list(:payment, 5, user: user)
        create_list(:payment, 2, user: user, purchase_cart: cart)
      end

      it 'fails' do
        expect(result.success?).to eq(false)
      end

      it 'returns a cart not found failure code' do
        expect(result.failure[:code]).to eq(:purchase_cart_not_found)
      end
    end
  end
end
