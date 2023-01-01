require 'rails_helper'

RSpec.describe Api::V1::Payments::Finder do
  subject(:finder) { described_class.new(payment_uuid: payment_uuid, user: user) }

  let(:user) { create(:user) }
  let(:payment) { create(:payment, user: user) }
  let(:payment_uuid) { payment.uuid }

  describe '#call' do
    subject(:result) { finder.call }

    it 'succeeds' do
      expect(result.success?).to eq(true)
    end

    it 'returns the payment record' do
      expect(result.value!).to eq(payment)
    end

    describe "when payment isn't found" do
      before do
        payment.destroy
      end

      it 'returns a failure' do
        expect(result.failure?).to eq(true)
      end

      it 'returns the right error code' do
        expect(result.failure[:code]).to eq(:payment_not_found)
      end
    end
  end
end
