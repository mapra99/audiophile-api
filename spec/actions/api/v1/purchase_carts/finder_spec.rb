require 'rails_helper'

RSpec.describe Api::V1::PurchaseCarts::Finder do
  subject(:finder) { described_class.new(cart_uuid: cart_uuid, session: session) }

  let(:session) { create(:session) }
  let(:cart) { create(:purchase_cart, session: session) }
  let(:cart_uuid) { cart.uuid }

  describe '#call' do
    subject(:result) { finder.call }

    it 'succeeds' do
      expect(result.success?).to eq(true)
    end

    it 'returns the cart record' do
      expect(result.value!).to eq(cart)
    end

    describe "when cart isn't found" do
      before do
        cart.destroy
      end

      it 'returns a failure' do
        expect(result.failure?).to eq(true)
      end

      it 'returns the right error code' do
        expect(result.failure[:code]).to eq(:cart_not_found)
      end
    end
  end
end
