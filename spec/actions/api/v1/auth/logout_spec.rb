require 'rails_helper'

RSpec.describe Api::V1::Auth::Logout do
  subject(:action) { described_class.new(user: user, access_token: access_token) }

  let(:user) { create(:user) }
  let(:access_token) { create(:access_token, user: user, status: AccessToken::ACTIVE) }

  describe '#call' do
    subject(:result) { action.call }

    let(:token_revoker) do
      instance_double(Authentication::AccessTokens::Revoker, call: true)
    end

    before do
      allow(Authentication::AccessTokens::Revoker).to receive(:new).and_return(token_revoker)
      allow(Authentication::AccessTokens::RevokerJob).to receive(:kill!).and_return(true)
    end

    it 'succeeds' do
      expect(result.success?).to eq(true)
    end

    it 'calls the code revoker' do
      action.call
      expect(token_revoker).to have_received(:call)
    end

    it 'kills the revoker job' do
      action.call
      expect(Authentication::AccessTokens::RevokerJob).to have_received(:kill!)
    end

    describe 'when service fails due to unhandled error' do
      before do
        allow(token_revoker).to receive(:call).and_raise(StandardError, 'ERROR MESSAGE')
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
