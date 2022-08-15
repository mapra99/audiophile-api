require 'rails_helper'

RSpec.describe Authentication::AccessTokens::Generator do
  subject(:generator) { described_class.new(user: user, verification_code: verification_code) }

  let(:user) { create(:user) }
  let(:verification_code) { create(:verification_code, user: user) }

  describe '#call' do
    let(:expiration_scheduler) { instance_double(Authentication::AccessTokens::ExpirationScheduler, call: true) }

    describe 'when successful' do
      before do
        allow(Authentication::AccessTokens::ExpirationScheduler).to receive(:new).and_return(expiration_scheduler)

        generator.call
      end

      it 'creates an access token' do
        expect(generator.access_token).not_to be_nil
      end

      it 'schedules the expiration' do
        expect(expiration_scheduler).to have_received(:call)
      end
    end
  end
end
