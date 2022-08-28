require 'rails_helper'

RSpec.describe Api::V1::Auth::Confirmation do
  subject(:action) { described_class.new(params: { email: user_email, code: code }, session: session) }

  let(:user) { create(:user) }
  let(:user_email) { user.email }

  let(:code) { '000000' }
  let(:verification_code) { create(:verification_code, user: user, code: code) }

  let(:access_token) { create(:access_token, user: user, verification_code: verification_code) }
  let(:session) { create(:session, user: nil) }

  describe '#call' do
    subject(:result) { action.call }

    let(:code_checker) do
      instance_double(Authentication::VerificationCodes::Checker, call: true, verification_code: verification_code)
    end

    let(:token_generator) do
      instance_double(Authentication::AccessTokens::Generator, call: true, access_token: access_token)
    end

    before do
      allow(Authentication::VerificationCodes::Checker).to receive(:new).and_return(code_checker)
      allow(Authentication::AccessTokens::Generator).to receive(:new).and_return(token_generator)
    end

    it 'succeeds' do
      expect(result.success?).to eq(true)
    end

    it 'calls the code checker' do
      action.call
      expect(code_checker).to have_received(:call)
    end

    it 'updates the session with the user' do
      action.call
      expect(session.user).to eq(user)
    end

    describe 'when service fails due to unhandled error' do
      before do
        allow(code_checker).to receive(:call).and_raise(StandardError, 'ERROR MESSAGE')
      end

      it 'returns a failure' do
        expect(result.failure?).to eq(true)
      end

      it 'returns internal_error as failure code' do
        expect(result.failure[:code]).to eq(:internal_error)
      end
    end

    describe 'when code is incorrect' do
      before do
        allow(code_checker).to receive(:call).and_raise(
          Authentication::VerificationCodes::IncorrectCode.new(user.id, code)
        )
      end

      it 'returns a failure' do
        expect(result.failure?).to eq(true)
      end

      it 'returns the right error code' do
        expect(result.failure[:code]).to eq(:incorrect_code)
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

    describe 'when there is no started code for user' do
      before do
        allow(code_checker).to receive(:call).and_raise(Authentication::VerificationCodes::NoStartedCodes.new(user.id))
      end

      it 'returns a failure' do
        expect(result.failure?).to eq(true)
      end

      it 'returns the right error code' do
        expect(result.failure[:code]).to eq(:no_started_codes)
      end
    end

    describe 'when token cannot be created' do
      before do
        allow(token_generator).to receive(:call).and_raise(Authentication::AccessTokens::InvalidToken.new(['error']))
      end

      it 'returns a failure' do
        expect(result.failure?).to eq(true)
      end

      it 'returns the right error code' do
        expect(result.failure[:code]).to eq(:invalid_token)
      end
    end
  end
end
