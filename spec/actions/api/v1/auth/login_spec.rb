require 'rails_helper'

RSpec.describe Api::V1::Auth::Login do
  subject(:action) { described_class.new(email: user_email) }

  let(:user) { create(:user) }
  let(:user_email) { user.email }
  let(:verification_code) { create(:verification_code) }

  describe '#call' do
    subject(:result) { action.call }

    let(:code_generator) do
      instance_double(Authentication::VerificationCodes::Generator, call: true, verification_code: verification_code)
    end

    before do
      allow(Authentication::VerificationCodes::Generator).to receive(:new).and_return(code_generator)
    end

    it 'succeeds' do
      expect(result.success?).to eq(true)
    end

    it 'calls the code generator' do
      action.call
      expect(code_generator).to have_received(:call)
    end

    describe 'when service fails due to unhandled error' do
      before do
        allow(code_generator).to receive(:call).and_raise(StandardError, 'ERROR MESSAGE')
      end

      it 'returns a failure' do
        expect(result.failure?).to eq(true)
      end

      it 'returns internal_error as failure code' do
        expect(result.failure[:code]).to eq(:internal_error)
      end
    end

    describe "when code cann't be created" do
      before do
        allow(code_generator).to receive(:call).and_raise(Authentication::VerificationCodes::InvalidCode.new(['error']))
      end

      it 'returns a failure' do
        expect(result.failure?).to eq(true)
      end

      it 'returns the right error code' do
        expect(result.failure[:code]).to eq(:code_not_created)
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
