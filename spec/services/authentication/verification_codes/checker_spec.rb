require 'rails_helper'

RSpec.describe Authentication::VerificationCodes::Checker do
  subject(:checker) { described_class.new(user: user, code: input_code) }

  let(:user) { create(:user) }
  let(:input_code) { '123456' }

  describe '#call' do
    describe 'when successful' do
      before do
        create(:verification_code, user: user, status: VerificationCode::STARTED, code: input_code)
        allow(Authentication::VerificationCodes::RevokerJob).to receive(:kill!).and_return(true)

        checker.call
      end

      it 'moves the code status to used' do
        expect(checker.verification_code.status).to eq(VerificationCode::USED)
      end
    end

    describe 'when the user does not have any started code' do
      it 'raises an error' do
        expect { checker.call }.to raise_error(Authentication::VerificationCodes::NoStartedCodes)
      end
    end

    describe 'when the user code is incorrect' do
      before do
        create(:verification_code, user: user, status: VerificationCode::STARTED, code: '000000')
      end

      it 'raises an error' do
        expect { checker.call }.to raise_error(Authentication::VerificationCodes::IncorrectCode)
      end
    end
  end
end
