require 'rails_helper'

RSpec.describe Api::V1::PurchaseCarts::Creator do
  subject(:creator) { described_class.new(params: params, session: session) }

  let(:session) { create(:session) }
  let(:params) do
    {
      items: [
        {
          stock_uuid: '123abc',
          quantity: 1
        }, {
          stock_uuid: '456def',
          quantity: 5
        }
      ]
    }
  end

  describe '#call' do
    subject(:result) { creator.call }

    let(:cart_item_generator) { instance_double(Purchases::CartItemGenerator, call: true) }
    let(:extra_fees_generator) { instance_double(Purchases::ExtraFeesGenerator, call: true) }

    before do
      allow(Purchases::CartItemGenerator).to receive(:new).and_return(cart_item_generator)
      allow(Purchases::ExtraFeesGenerator).to receive(:new).and_return(extra_fees_generator)
    end

    it 'succeeds' do
      expect(result.success?).to eq(true)
    end

    it 'creates a new cart' do
      expect { creator.call }.to change(PurchaseCart, :count).by(1)
    end

    it 'calls the item generator service once per item' do
      creator.call
      expect(cart_item_generator).to have_received(:call).exactly(2)
    end

    it 'calls the extra fees generator service' do
      creator.call
      expect(extra_fees_generator).to have_received(:call).exactly(1)
    end

    describe 'when service failes due to unhandled error' do
      before do
        allow(Purchases::CartItemGenerator).to receive(:new).and_raise(StandardError, 'ERROR MESSAGE')
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

    describe 'when extra fee is invalid' do
      before do
        allow(extra_fees_generator).to receive(:call).and_raise(Purchases::InvalidExtraFee.new([]))
      end

      it 'returns a failure' do
        expect(result.failure?).to eq(true)
      end

      it 'returns the right error code' do
        expect(result.failure[:code]).to eq(:invalid_extra_fee)
      end
    end
  end
end
