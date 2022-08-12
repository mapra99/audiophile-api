require 'rails_helper'

RSpec.describe Authentication::VerificationCodes::RevokerJob, type: :job do
  let(:verification_code) { create(:verification_code) }

  let(:code_revoker) { instance_double(Authentication::VerificationCodes::Revoker, call: true) }

  before do
    allow(Authentication::VerificationCodes::Revoker).to receive(:new).and_return(code_revoker)

    described_class.perform_now(verification_code_id: verification_code.id)
  end

  it 'calls the email sender service' do
    expect(code_revoker).to have_received(:call)
  end
end
