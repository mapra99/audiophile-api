require 'rails_helper'

RSpec.describe Authentication::VerificationCodes::Revoker do
  subject(:revoker) { described_class.new(verification_code_id: code_id) }

  let(:verification_code) { create(:verification_code, status: VerificationCode::STARTED) }
  let(:code_id) { verification_code.id }

  describe '#call' do
    describe 'when successful' do
      before do
        revoker.call
      end

      it 'moves the code status to expired' do
        expect(verification_code.reload.status).to eq(VerificationCode::EXPIRED)
      end
    end
  end
end
