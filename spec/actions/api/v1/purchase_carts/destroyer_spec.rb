require 'rails_helper'

RSpec.describe Api::V1::PurchaseCarts::Destroyer do
  subject(:destroyer) { described_class.new(cart_uuid: cart_uuid, session: session) }

  let(:session) { create(:session) }
  let(:cart) { create(:purchase_cart, session: session) }
  let(:cart_uuid) { cart.uuid }

  describe '#call' do
    subject(:result) { destroyer.call }

    let(:cart_canceler) { instance_double(Purchases::CartCanceler, call: true) }

    before do
      allow(Purchases::CartCanceler).to receive(:new).and_return(cart_canceler)

      destroyer.call
    end

    it 'succeeds' do
      expect(result.success?).to eq(true)
    end

    it 'calls the cart canceler' do
      expect(cart_canceler).to have_received(:call)
    end

    describe 'when service failes due to unhandled error' do
      before do
        allow(cart_canceler).to receive(:call).and_raise(StandardError, 'ERROR MESSAGE')
      end

      it 'returns a failure' do
        expect(result.failure?).to eq(true)
      end

      it 'returns internal_error as failure code' do
        expect(result.failure[:code]).to eq(:internal_error)
      end
    end

    describe "when cart isn't found" do
      before do
        allow(cart_canceler).to receive(:call).and_raise(Purchases::CartNotFound.new(any_args))
      end

      it 'returns a failure' do
        expect(result.failure?).to eq(true)
      end

      it 'returns the right error code' do
        expect(result.failure[:code]).to eq(:cart_not_found)
      end
    end

    describe 'when cart has invalid status' do
      before do
        allow(cart_canceler).to receive(:call).and_raise(Purchases::InvalidStatusForCancelation.new(any_args))
      end

      it 'returns a failure' do
        expect(result.failure?).to eq(true)
      end

      it 'returns the right error code' do
        expect(result.failure[:code]).to eq(:invalid_status)
      end
    end
  end
end
