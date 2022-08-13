require 'rails_helper'

RSpec.describe VerificationCode, type: :model do
  subject(:code) { build(:verification_code) }

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_one(:access_token) }
  end

  describe 'validations' do
    it { is_expected.to have_secure_password(:code) }
    it { is_expected.to validate_presence_of(:expires_at) }
    it { is_expected.to validate_presence_of(:status) }

    describe 'when the code is started and it belongs to a user with an existing started code' do
      subject(:code) { build(:verification_code, user: user, status: VerificationCode::STARTED) }

      let(:user) { create(:user) }

      before do
        create(:verification_code, user: user, status: VerificationCode::STARTED)
      end

      it 'is not valid' do
        expect(code.valid?).to eq(false)
      end
    end
  end
end
