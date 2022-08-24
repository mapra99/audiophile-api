require 'rails_helper'

RSpec.describe Api::V1::CartItems::Creator do
  subject(:creator) { described_class.new(cart_uuid: cart_uuid, item_params: params, session: session) }

  let(:session) { create(:session) }
  let(:cart_uuid) { create(:purchase_cart, session: session).uuid }
  let(:params) do
    {
      stock_uuid: '123abc',
      quantity: 1
    }
  end

  describe '#call' do
    subject(:result) { creator.call }

    let(:cart_item_generator) { instance_double(Purchases::CartItemGenerator, call: true, cart_item: true) }

    before do
      allow(Purchases::CartItemGenerator).to receive(:new).and_return(cart_item_generator)

      creator.call
    end

    it 'succeeds' do
      expect(result.success?).to eq(true)
    end

    it 'calls the item generator' do
      expect(cart_item_generator).to have_received(:call)
    end

    describe 'when service fails due to unhandled error' do
      before do
        allow(cart_item_generator).to receive(:call).and_raise(StandardError, 'ERROR MESSAGE')
      end

      it 'returns a failure' do
        expect(result.failure?).to eq(true)
      end

      it 'returns internal_error as failure code' do
        expect(result.failure[:code]).to eq(:internal_error)
      end
    end

    describe "when stock isn't found" do
      before do
        allow(cart_item_generator).to receive(:call).and_raise(Purchases::StockNotFound.new(any_args))
      end

      it 'returns a failure' do
        expect(result.failure?).to eq(true)
      end

      it 'returns the right error code' do
        expect(result.failure[:code]).to eq(:stock_not_found)
      end
    end

    describe 'when there is not enough stock' do
      before do
        allow(cart_item_generator).to receive(:call).and_raise(Purchases::InsufficientStock.new(any_args, any_args))
      end

      it 'returns a failure' do
        expect(result.failure?).to eq(true)
      end

      it 'returns the right error code' do
        expect(result.failure[:code]).to eq(:insufficient_stock)
      end
    end

    describe 'when a cart item was invalid' do
      before do
        allow(cart_item_generator).to receive(:call).and_raise(Purchases::InvalidCartItem.new([]))
      end

      it 'returns a failure' do
        expect(result.failure?).to eq(true)
      end

      it 'returns the right error code' do
        expect(result.failure[:code]).to eq(:invalid_cart_item)
      end
    end

    describe 'when cart is not found' do
      before do
        allow(cart_item_generator).to receive(:call).and_raise(Purchases::CartNotFound.new(any_args))
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
