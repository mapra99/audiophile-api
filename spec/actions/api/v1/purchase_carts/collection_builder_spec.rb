require 'rails_helper'

RSpec.describe Api::V1::PurchaseCarts::CollectionBuilder do
  subject(:builder) { described_class.new(session: session) }

  let(:session) { create(:session) }

  describe '#call' do
    subject(:result) { builder.call }

    before do
      create_list(:purchase_cart, 5, session: session, status: [PurchaseCart::PAID, PurchaseCart::CANCELED].sample)

      builder.call
    end

    it 'succeeds' do
      expect(result.success?).to eq(true)
    end

    it 'returns an array with the purchse carts that belong to the session' do
      expect(result.value!.count).to eq(5)
    end

    describe 'when service failes due to unhandled error' do
      before do
        allow(session).to receive(:purchase_carts).and_raise(StandardError, 'ERROR MESSAGE')
      end

      it 'returns a failure' do
        expect(result.failure?).to eq(true)
      end

      it 'returns internal_error as failure code' do
        expect(result.failure[:code]).to eq(:internal_error)
      end
    end
  end
end
