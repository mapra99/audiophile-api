require 'rails_helper'

RSpec.describe Api::V1::Auth::VerificationStatus do
  subject(:action) { described_class.new(email: user_email) }

  let(:user) { create(:user) }
  let(:user_email) { user.email }
  let(:code_status) { VerificationCode::STARTED }

  describe '#call' do
    subject(:result) { action.call }

    before do
      create(:verification_code, user: user, status: code_status)
    end

    it 'succeeds' do
      expect(result.success?).to eq(true)
    end

    it 'returns the user active verification code' do
      expect(result.value!).not_to be_nil
    end

    describe 'when the code is already expired' do
      let(:code_status) { VerificationCode::EXPIRED }

      it 'returns nothing' do
        expect(result.value!).to be_nil
      end
    end

    describe 'when user is not found' do
      let(:user_email) { 'non-existing-user@example.com' }

      it 'returns a failure' do
        expect(result.failure?).to eq(true)
      end

      it 'returns the right error code' do
        expect(result.failure[:code]).to eq(:user_not_found)
      end
    end
  end
end
