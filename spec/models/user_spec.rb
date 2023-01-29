require 'rails_helper'

RSpec.describe User, type: :model do
  subject(:user) { build(:user) }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:phone) }
    it { is_expected.to validate_uniqueness_of(:email) }

    describe 'email format' do
      it { is_expected.to allow_value('email@addresse.foo').for(:email) }
      it { is_expected.not_to allow_value('foo').for(:email) }
    end
  end

  describe 'associations' do
    it { is_expected.to have_many(:email_communications) }
    it { is_expected.to have_many(:verification_codes) }
    it { is_expected.to have_many(:access_tokens) }
    it { is_expected.to have_many(:user_locations) }
    it { is_expected.to have_many(:locations) }
    it { is_expected.to have_many(:sessions) }
    it { is_expected.to have_many(:purchase_carts) }
    it { is_expected.to have_many(:payments) }
  end

  describe '#latest_started_verification_code' do
    subject(:user) { create(:user) }

    let(:started_code) { create(:verification_code, user: user, status: VerificationCode::STARTED) }

    before do
      create_list(:verification_code, 10, user: user, status: VerificationCode::EXPIRED)
      started_code
    end

    it 'returns the started code' do
      expect(user.latest_started_verification_code).to eq(started_code)
    end

    describe 'when there is no started code' do
      before do
        started_code.update(status: VerificationCode::EXPIRED)
      end

      it 'returns nil' do
        expect(user.latest_started_verification_code).to eq(nil)
      end
    end
  end
end
