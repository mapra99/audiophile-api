require 'rails_helper'

RSpec.describe Authentication::AccessTokens::RevokerJob, type: :job do
  let(:access_token) { create(:access_token) }

  let(:token_revoker) { instance_double(Authentication::AccessTokens::Revoker, call: true) }

  before do
    allow(Authentication::AccessTokens::Revoker).to receive(:new).and_return(token_revoker)

    described_class.perform_now(access_token_id: access_token.id)
  end

  it 'calls the token revoker service' do
    expect(token_revoker).to have_received(:call)
  end
end
