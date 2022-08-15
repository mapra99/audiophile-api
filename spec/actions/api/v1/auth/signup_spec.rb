require 'rails_helper'

RSpec.describe Api::V1::Auth::Signup do
  subject(:action) { described_class.new(params: params) }

  let(:params) do
    {
      name: 'Jhon Doe',
      email: 'jhon.doe+20220814-2@gmail.com',
      phone: '1112223333'
    }
  end
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

    it 'creates the user' do
      expect { action.call }.to change(User, :count).by(1)
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

    describe 'when user is invalid' do
      before do
        create(:user, email: 'jhon.doe+20220814-2@gmail.com')
      end

      it 'returns a failure' do
        expect(result.failure?).to eq(true)
      end

      it 'returns the right error code' do
        expect(result.failure[:code]).to eq(:invalid_user)
      end
    end
  end
end
