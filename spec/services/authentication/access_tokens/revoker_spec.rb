require 'rails_helper'

RSpec.describe Authentication::AccessTokens::Revoker do
  subject(:revoker) { described_class.new(access_token_id: token_id) }

  let(:access_token) { create(:access_token, status: AccessToken::ACTIVE) }
  let(:token_id) { access_token.id }

  describe '#call' do
    describe 'when successful' do
      before do
        revoker.call
      end

      it 'moves the token status to expired' do
        expect(access_token.reload.status).to eq(AccessToken::EXPIRED)
      end
    end
  end
end
