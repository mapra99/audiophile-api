require 'rails_helper'

RSpec.describe Authentication::VerificationCodes::Generator do
  subject(:generator) { described_class.new(user: user) }

  let(:user) { create(:user) }

  describe '#call' do
    let(:expiration_scheduler) { instance_double(Authentication::VerificationCodes::ExpirationScheduler, call: true) }

    describe 'when successful' do
      before do
        allow(Authentication::VerificationCodes::ExpirationScheduler).to receive(:new).and_return(expiration_scheduler)
        allow(Communications::EmailSenderJob).to receive(:perform_later).and_return(true)

        generator.call
      end

      it 'creates a verification token' do
        expect(generator.verification_code).not_to be_nil
      end

      it 'schedules the expiration' do
        expect(expiration_scheduler).to have_received(:call)
      end

      it 'sends the email with the verification code' do
        expect(Communications::EmailSenderJob).to have_received(:perform_later)
      end
    end

    describe 'when code cannot be created' do
      before do
        create(:verification_code, user: user, status: VerificationCode::STARTED)

        allow(Authentication::VerificationCodes::ExpirationScheduler).to receive(:new).and_return(expiration_scheduler)
        allow(Communications::EmailSenderJob).to receive(:perform_later).and_return(true)
      end

      it 'returns an error' do
        expect { generator.call }.to raise_error(Authentication::VerificationCodes::InvalidCode)
      end
    end
  end
end
