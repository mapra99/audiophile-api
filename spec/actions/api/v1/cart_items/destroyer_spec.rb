require 'rails_helper'

RSpec.describe Api::V1::CartItems::Destroyer do
  subject(:destroyer) { described_class.new(item_uuid: item_uuid, session: session) }

  let(:session) { create(:session) }
  let(:purchase_cart) { create(:purchase_cart, session: session) }
  let(:cart_item) { create(:purchase_cart_item, purchase_cart: purchase_cart) }
  let(:item_uuid) { cart_item.uuid }

  describe '#call' do
    subject(:result) { destroyer.call }

    let(:item_remover) { instance_double(Purchases::CartItemRemover, call: true) }

    before do
      allow(Purchases::CartItemRemover).to receive(:new).and_return(item_remover)

      destroyer.call
    end

    it 'succeeds' do
      expect(result.success?).to eq(true)
    end

    it 'calls the cart item remover' do
      expect(item_remover).to have_received(:call)
    end

    describe 'when service fails due to unhandled error' do
      before do
        allow(item_remover).to receive(:call).and_raise(StandardError, 'ERROR MESSAGE')
      end

      it 'returns a failure' do
        expect(result.failure?).to eq(true)
      end

      it 'returns internal_error as failure code' do
        expect(result.failure[:code]).to eq(:internal_error)
      end
    end

    describe "when item isn't found" do
      before do
        allow(item_remover).to receive(:call).and_raise(Purchases::CartItemNotFound.new(any_args))
      end

      it 'returns a failure' do
        expect(result.failure?).to eq(true)
      end

      it 'returns the right error code' do
        expect(result.failure[:code]).to eq(:cart_item_not_found)
      end
    end
  end
end
