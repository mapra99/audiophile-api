require 'rails_helper'

RSpec.describe Api::V1::PurchaseCarts::Updater do
  subject(:updater) { described_class.new(params: params, owner: owner) }

  let(:owner) { session }
  let(:session) { create(:session) }
  let(:purchase_cart) { create(:purchase_cart, session: session, user_location: nil) }
  let(:user_location) do
    VCR.use_cassette('geocoder_response', match_requests_on: %i[method host path]) do
      create(:user_location)
    end
  end
  let(:user_location_uuid) { user_location.uuid }
  let(:purchase_cart_uuid) { purchase_cart.uuid }
  let(:params) do
    {
      uuid: purchase_cart_uuid,
      user_location_uuid: user_location_uuid
    }
  end

  describe '#call' do
    subject(:result) { updater.call }

    it 'succeeds' do
      expect(result.success?).to eq(true)
    end

    it 'updates the cart user_location' do
      updater.call

      expect(purchase_cart.reload.user_location).to eq(user_location)
    end

    describe 'when service failes due to unhandled error' do
      let(:user_location_uuid) { 'abc123' }

      it 'returns a failure' do
        expect(result.failure?).to eq(true)
      end

      it 'returns internal_error as failure code' do
        expect(result.failure[:code]).to eq(:internal_error)
      end
    end

    describe "when cart isn't found" do
      let(:purchase_cart_uuid) { 'abc123' }

      it 'returns a failure' do
        expect(result.failure?).to eq(true)
      end

      it 'returns the right error code' do
        expect(result.failure[:code]).to eq(:cart_not_found)
      end
    end

    describe 'when owner is user' do
      let(:owner) { user }
      let(:user) { create(:user) }
      let(:purchase_cart) { create(:purchase_cart, user: user, user_location: nil) }

      it 'succeeds' do
        expect(result.success?).to eq(true)
      end

      it 'updates the cart user_location' do
        updater.call

        expect(purchase_cart.reload.user_location).to eq(user_location)
      end
    end
  end
end
